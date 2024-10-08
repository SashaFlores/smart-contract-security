# Denial of Service: Withdraw Pattern

### Description

- The Withdraw Pattern is a design pattern that can occur when a malicious  user prevents  others from withdrawing their funds by exploiting the way withdrawals are processed. 

- This pattern typically happens when funds are sent to multiple users in a single transaction or within a loop.  

- This pattern is commonly used in contracts that hold user funds, such as wallets or token contracts.

### Severity Level : 

- Medium

### Impact: 

- in `Withdraw` contract the owner can lock funds of users staking their funds in the contract.

- Contract owner can `renounceOwnership` to zero address preventing users from withdrawing their funds and stuck in contract forever.

### Recommendation


### References

- [LinkedIn Challenge Post](https://www.linkedin.com/feed/update/urn:li:activity:7247869201095299073/)

- [Original Code Repository](https://github.com/code-423n4/2022-06-putty/blob/3b6b844bc39e897bd0bbb69897f2deff12dc3893/contracts/src/PuttyV2.sol#L466)