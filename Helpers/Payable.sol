// SPDX-License-Identifier: MIT

pragma solidity 0.8.17; 

contract PayableDemo {

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner"); 
        _;
    } 

    function deposit() public payable {

    }

    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner { 
        uint balance = getBalance();
        owner.transfer(balance); 
    }

    function transfer(address payable _to, uint _amount) public onlyOwner { 
        _to.transfer(_amount);
    }    

}