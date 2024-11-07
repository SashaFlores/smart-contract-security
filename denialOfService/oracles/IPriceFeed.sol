// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

interface IPriceFeed {
  function currentPrice(uint256 _targetDecimals) external view returns (uint256);
}