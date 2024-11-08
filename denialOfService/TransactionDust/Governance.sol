// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Governance {
    using SafeERC20 for IERC20;

    struct Governance {
        address user;
        uint amount;
    }

    Withdrawal[] public withdrawals;

    IERC20 public immutable reserveToken;

    // withdrawals will start processing at withdrawals[start]
    uint public start;

    uint public constant maxWithdrawalProcesses = 100;
    uint8 public constant decimals = 6;

    constructor(address _reserveToken) {
        require(_reserveToken != address(0), "address zero!");
        reserveToken = IERC20(_reserveToken);
    }

     function mintWithReserve(address to, uint amount) external {
        reserveToken.safeTransferFrom(msg.sender, address(this), amount);
        _mint(to, amount);
    }

    function withdraw(uint amount) external {
        burn(amount);
        withdrawals.push(Withdrawal(msg.sender, amount));
    }

    function processWithdrawals() external {
        uint reserve = reserveToken.balanceOf(address(this));
        require(reserve >= withdrawals[start].amount, 'Cannot process withdrawals at this time: Not enough balance');
        uint i = start;
        while (i < withdrawals.length && (i - start) <= maxWithdrawalProcesses) {
            Withdrawal memory withdrawal = withdrawals[i];
            if (reserve < withdrawal.amount) {
                break;
            }
            reserveToken.safeTransfer(withdrawal.user, withdrawal.amount);
            reserve -= withdrawal.amount;
            i += 1;
        }
        start = i;
    }
}