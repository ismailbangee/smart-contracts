// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

// Permanently stored in contract storage
contract State{
    uint public age1;
    uint public age2 = 10;
    uint public age3;

    constructor(){
        age3 = 20;
    }

    function setAge1(uint _x) public{
        age1 = _x;
    }

    function setAge1As40() public{
        age1 = 40;
    }
}
