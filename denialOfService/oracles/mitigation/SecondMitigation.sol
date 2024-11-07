// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {FixedPointDecimal} from "./FixedPointDecimal.sol";
import {IPriceFeed} from './IPriceFeed.sol';

contract SecondMitigation is IPriceFeed{
    using FixedPointDecimal for uint256;


    AggregatorV3Interface public feed;
    uint256 public immutable maxPriceAge;

    constructor(AggregatorV3Interface _feed, uint256 _maxPriceAge) {
        feed = _feed;
        maxPriceAge = _maxPriceAge;
    }

    function currentPrice(uint256 _decimals) external view override returns (uint256) {
        try feed.latestRoundData() returns (, int256 price, , uint256 updatedAt, ) {
            
            require(price > 0, "PrimaryPriceFeed: Invalid price from feed");
            require(block.timestamp - updatedAt <= maxPriceAge, "PrimaryPriceFeed: Stale data from feed");
            
            uint256 _feedDecimals = feed.decimals();

            // Return the price, adjusted to the target decimals.
            return uint256(price).adjustDecimals(_feedDecimals, _decimals);
        } catch {
            // Handle the failure case by reverting with a descriptive error
            revert("PriceFeed: Failed to retrieve latest price data");
        }
    }
}