# Denial of Service: Withdraw Pattern

### Description

- The Withdraw Pattern is a design pattern that can occur when a malicious  user prevents  others from withdrawing their funds by exploiting the way withdrawals are processed. 

- This pattern typically happens when funds are sent to multiple users in a single transaction or within a loop.  

- This pattern is commonly used in contracts that hold user funds, such as wallets or token contracts.


### Severity Level : 

- Medium: line 46 in `Withdraw` contract.

### Impact: 

- in `Withdraw` contract the owner can lock funds of users staking their funds in the contract.

- Contract owner can `renounceOwnership` to zero address preventing users from withdrawing their funds and stuck in contract forever.

### Recommendation

- Instead of transferring fees directly to owner in the same `withdraw` function, separate withdrawal fees from user funds.

- In Solidity, pull payments (also called withdrawal patterns) are generally safer than pushing payments (direct transfers) when handling funds. Here’s why:


    - Decoupling logic and payments: In the pull pattern, the contract stores the amount owed to each user. Users must then "pull" their funds by calling a separate function to withdraw. This decouples the core logic of the contract from fund distribution, reducing the risk of errors or gas issues during execution.

    - Handling gas limitations: Sending ether to multiple addresses in a single transaction (push pattern) can fail due to gas limitations or issues with a recipient’s contract. With the pull pattern, users withdraw their funds individually, avoiding gas problems and allowing better control over execution.

### References

- [LinkedIn Challenge Post](https://www.linkedin.com/feed/update/urn:li:activity:7247869201095299073/)

- [Original Code Repository](https://github.com/code-423n4/2022-06-putty/blob/3b6b844bc39e897bd0bbb69897f2deff12dc3893/contracts/src/PuttyV2.sol#L466)