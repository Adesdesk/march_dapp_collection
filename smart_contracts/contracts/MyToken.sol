// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// @author - Adeola David Adelakun

contract MyToken {
    // Mapping to keep track of each user's token balance
    mapping(address => uint256) public balances;

    // Emit this event whenever tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Constructor to set the initial supply of tokens and assign them to the contract deployer
    constructor(uint256 initialSupply) {
        balances[msg.sender] = initialSupply;
    }

    // Function to enable users transfer tokens to one another
    function transfer(address to, uint256 value) public returns (bool) {
        // Check that the sender has enough tokens to send
        require(balances[msg.sender] >= value, "Insufficient balance");

        // Check that the recipient address is valid
        require(to != address(0), "Invalid recipient address");

        // Reduce the sender's balance and increase the recipient's balance by appropriate amounts
        balances[msg.sender] -= value;
        balances[to] += value;

        // Emit an event to indicating that tokens have been transferred successfully
        emit Transfer(msg.sender, to, value);

        return true;
    }
}
