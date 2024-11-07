// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {IPriceFeed} from './IPriceFeed.sol';

contract Prices {

    mapping(uint256 => mapping(uint256 => IPriceFeed)) public feeds;

    error PRICE_FEED_NOT_FOUND();


    function priceFor(
        uint256 _currency,
        uint256 _base,
        uint256 _decimals
    ) external view returns (uint256) {
        // If the currency is the base, return 1 since they are priced the same. Include the desired number of decimals.
        if (_currency == _base) return 10**_decimals;

        // Get a reference to the feed.
        IPriceFeed _feed = feeds[_currency][_base];

        // If it exists, return the price.
        if (_feed != IPriceFeed(address(0))) return _feed.currentPrice(_decimals);

        // No price feed available, revert.
        revert PRICE_FEED_NOT_FOUND();
    }

}