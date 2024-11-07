// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {FixedPointDecimal} from "./FixedPointDecimal.sol";
import {IPriceFeed} from './IPriceFeed.sol';

contract PriceFeed is IPriceFeed{
    using FixedPointDecimal for uint256;
    
    AggregatorV3Interface public feed;

    constructor(AggregatorV3Interface _feed) {
        feed = _feed;
    }

    function currentPrice(uint256 _decimals) external view override returns (uint256) {
        (, int256 price, , , ) = feed.latestRoundData();
        uint256 _feedDecimals = feed.decimals();
        // Return the price, adjusted to the target decimals.
        return uint256(price).adjustDecimals(_feedDecimals, _decimals);
    }
}
