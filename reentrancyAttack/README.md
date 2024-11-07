# Reentrancy Attack


A reentrancy attack is a type of exploit in smart contracts where an attacker repeatedly calls a vulnerable contract's function before the previous function execution is completed. This allows the attacker to manipulate the contract's state in an unintended way, often leading to significant financial losses.

 ### *How It Works*

#### *1- Initial Call:*

The attacker initiates a call to a function in the vulnerable contract, such as a withdrawal function.


#### *2- External Call:*

The vulnerable contract makes an external call, such as sending ether to the attacker's contract.


#### *3- Fallback Function:* 

The attacker's contract has a fallback function that is triggered by the external call. This fallback function re-enters the vulnerable contract's function before the state is updated.


#### *4- Re-Entry:* 

The fallback function calls the vulnerable function again, exploiting the fact that the contract's state has not yet been updated. This allows the attacker to withdraw more funds than they are entitled to.


### Severity Level : 

High

### Impact: 

The impact of this vulnerability includes:

- Financial Loss: 

The attacker can drain all the ether from the VulnerableBank contract.
Trust Issues: Users may lose trust in the contract and the platform, leading to reputational damage.

- Operational Disruption: 

The contract may become unusable until the issue is fixed and funds are restored.


### Recommended Mitigation

To mitigate the risk of reentrancy attacks, consider the following recommendations:

#### *1- Use the Checks-Effects-Interactions Pattern:*

Ensure that state changes (checks and effects) are made before any external calls (interactions).

```
function withdraw(uint _amount) public {
    // Check: Ensure the user has sufficient balance
    require(balances[msg.sender] >= _amount, "Insufficient balance");

    // Effect: Update the state before making the external call
    balances[msg.sender] -= _amount;

    // Interaction: Transfer the funds
    (bool success, ) = msg.sender.call{value: _amount}("");
    require(success, "Transfer failed");
}
```


#### *2- Use Reentrancy Guards:*

Implement a reentrancy guard to prevent reentrant calls:

```
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract VulnerableBank is ReentrancyGuard {
    function withdraw(uint _amount) public nonReentrant {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Update state before making the external call
        balances[msg.sender] -= _amount;

        // Transfer the funds
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }
}
```

#### *3- Limit Gas for External Calls:*

Limit the gas available for external calls to prevent reentrancy:
    
```
(bool success, ) = msg.sender.call{value: _amount, gas: 2300}("");
require(success, "Transfer failed");
```

#### *4- Use Pull Payments:*

Instead of sending funds directly, let users withdraw their funds:

```
function withdraw() public {
    uint amount = balances[msg.sender];
    require(amount > 0, "No funds to withdraw");

    // Update state before making the external call
    balances[msg.sender] = 0;

    // Transfer the funds
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```











