/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImplementationV1 {
    uint256 public value; 
    address public owner; 
    uint256[50] private __gap; 

    function setValue(uint256 _value) public {
        value = _value;
    }

    function setOwner(address _owner) public {
        owner = _owner;
    }
}

contract ImplementationV2 {
    uint256 public value; 
    address public owner; 
    uint256 public newValue; 
    uint256[50] private __gap; 

    function setValue(uint256 _value) public {
        value = _value;
    }

    function setNewValue(uint256 _newValue) public {
        newValue = _newValue;
    }

    function setOwner(address _owner) public {
        owner = _owner;
    }
}



contract ImplementationV2NoCollision {
    uint256 public value; // Slot 0
    address public owner; // Slot 1
    uint256 public newValue; // Slot 2
    uint256[49] private __gap; // Slots 3-51 (Adjusted to account for newValue)

    function setValue(uint256 _value) public {
        value = _value;
    }

    function setNewValue(uint256 _newValue) public {
        newValue = _newValue;
    }

    function setOwner(address _owner) public {
        owner = _owner;
    }
}