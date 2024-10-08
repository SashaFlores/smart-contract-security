pragma solidity ^0.8.26;

contract SafeWithdraw {

    mapping(address => uint256) private fees;


    /**
        @notice Withdraws the assets from a short order and also burns the short position 
                that represents it. The assets that are withdrawn are dependent on whether 
                the order is exercised or expired and if the order is a put or call.
        @param order The order to withdraw.
     */
    function withdraw(Order memory order) public {
        /* ~~~ CHECKS ~~~ */

        // check order is short
        require(!order.isLong, "Must be short position");

        bytes32 orderHash = hashOrder(order);

        // check msg.sender owns the position
        require(ownerOf(uint256(orderHash)) == msg.sender, "Not owner");

        uint256 longPositionId = uint256(hashOppositeOrder(order));
        bool isExercised = exercisedPositions[longPositionId];

        // check long position has either been exercised or is expired
        require(block.timestamp > positionExpirations[longPositionId] || isExercised, "Must be exercised or expired");

        /* ~~~ EFFECTS ~~~ */

        // send the short position to 0xdead.
        // instead of doing a standard burn by sending to 0x000...000, sending
        // to 0xdead ensures that the same position id cannot be minted again.
        transferFrom(msg.sender, address(0xdead), uint256(orderHash));

        emit WithdrawOrder(orderHash, order);

        /* ~~~ INTERACTIONS ~~~ */

        // transfer strike to owner if put is expired or call is exercised
        if ((order.isCall && isExercised) || (!order.isCall && !isExercised)) {
            // send the fee to the admin/DAO if fee is greater than 0%
            uint256 feeAmount = 0;
            if (fee > 0) {
                feeAmount = (order.strike * fee) / 1000;
                /*
                    Update the fee amount of owner if not Zero
                */

               fees[order.baseAsset] += feeAmount;
            }

            ERC20(order.baseAsset).safeTransfer(msg.sender, order.strike - feeAmount);

            return;
        }

        // transfer assets from putty to owner if put is exercised or call is expired
        if ((order.isCall && !isExercised) || (!order.isCall && isExercised)) {
            _transferERC20sOut(order.erc20Assets);
            _transferERC721sOut(order.erc721Assets);

            // for call options the floor token ids are saved in the long position in fillOrder(),
            // and for put options the floor tokens ids are saved in the short position in exercise()
            uint256 floorPositionId = order.isCall ? longPositionId : uint256(orderHash);
            _transferFloorsOut(order.floorTokens, positionFloorAssetTokenIds[floorPositionId]);

            return;
        }
    }

    /**
        @notice Withdraws the fees that have been collected for a specific base asset.
        @param baseAsset The base asset to withdraw the fees for.
        Separating owner fees withdrawal from user withdrawal
     */

    function withdrawFee(address baseAsset) public onlyOwner {
        uint256 amount = fees[baseAsset];
        require(amount > 0, "No fees to withdraw");
        fees[token] = 0;
        ERC20(token).safeTransfer(owner(), amount);
    }

}