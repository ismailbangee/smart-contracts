// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Transfer {

    address owner;

    /**
     * Initialize owenr address
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * Modifier function to check if this function is call by owner or not.
     */
    modifier ownable () {
        require(owner == msg.sender,"Only Owner Allowed to Perform This Action");
        _;
    }

    /**
     * Function to transfer ownership to new user.
     */
    function transferOwnership(address newAddress) public ownable {
        
        // Check the valid address
        require(newAddress != address(0),"Invalid Address");
        owner = newAddress;
    }
}