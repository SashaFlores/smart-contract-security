# Denial of Service: Oracle Price Feed Dependency

### Description

- The  `currentPrice` function relies entirely on the external `PriceFeed` contract `(feed.latestRoundData())` to provide pricing data. This creates a Denial of Service (DoS) risk because any issues or failures within the external contract will directly impact the availability of the currentPrice function in this contract. Since there are no internal checks or fallback mechanisms, any failure by the external feed will prevent the currentPrice function from returning valid data..

- If `feed.latestRoundData()` fails or if the external feed contract is paused, experiences an outage, or returns invalid data, the lack of internal control over the contract's state will effectively lock the currentPrice function. This vulnerability can result in a complete loss of functionality, as the contract fully relies on external conditions it does not control.

- This pattern is commonly used in contracts that hold user funds, such as wallets or token contracts.


### Severity Level : 

- High: line 19 in `currentPrice` contract which consequently affects `priceFor` function in `Prices` contract when returning the price of the current token in line 27.

### Impact: 

- If the external feed fails or returns stale data, this contract's `currentPrice` function will revert or produce incorrect data. This DoS vulnerability could severely disrupt contract operations, especially if other on-chain functions depend on accurate price data. 

- The lack of a fallback mechanism or error handling means that any prolonged issues with the external feed can cause extended outages or malfunctions in any system that depends on this data.

- Additionally, any failure in feed.latestRoundData()—even if temporary—means the contract is entirely dependent on external factors. Malicious actors or external feed issues can therefore prevent the contract from functioning, causing financial or operational disruptions.

### Recommendation

*FirstMitigation* 

The FirstMitigation contract mitigates DoS risk by using a simple try/catch block to handle potential failures in the external price feed contract. If the latestRoundData call fails, the contract reverts with an error message.

*Error Handling with try/catch:*

 The try/catch block prevents the entire function from failing due to external issues. By catching errors from latestRoundData, it prevents prolonged failures from locking up the contract and provides a controlled way to manage these failures.

Focused Error Reporting: When an error is caught, the contract provides a clear error message ("PriceFeed: Failed to retrieve latest price data"), which can be useful for off-chain monitoring. This message allows external tools to detect and address feed failures promptly without adding complexity to the contract.

*SecondMitigation* 

The SecondMitigation contract adds an additional layer of data validation to ensure that only fresh data from the feed is used. By including a `maxPriceAge` parameter, it ensures that the contract only uses recent data and reverts if the data is stale.



*1- Data Freshness Check:*

 The contract validates the age of the data retrieved from `latestRoundData` by comparing `updatedAt` against `maxPriceAge`. This ensures that outdated or stale data from the feed doesn’t influence the contract’s logic, improving reliability.

*2- Invalid Price Check:*

 The `require(price > 0, "PrimaryPriceFeed: Invalid price from feed")` statement ensures that the price data retrieved from the feed is positive. This prevents invalid or erroneous values from influencing price calculations, protecting against potential manipulation or data corruption in the external feed.

*3- Improved DoS Handling with Freshness Filter:* 

By reverting only when both the data is stale and latestRoundData fails, this approach reduces reliance on a single data point from the external feed. The require statement on data age ensures that stale data doesn’t introduce errors in price calculations, which is especially important in time-sensitive applications.


### References

- [LinkedIn Challenge Post](https://www.linkedin.com/feed/update/urn:li:activity:7260379465740873729/)

- [OZ Guidelines on Dangers of Price Oracles](https://blog.openzeppelin.com/secure-smart-contract-guidelines-the-dangers-of-price-oracles)

