// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// @author - Adeola David Adelakun

contract Lottery {
    // declaring owner and ticketHolders variables
    address public owner;
    address payable[] public ticketHolders;

    // constructor function to set the owner
    constructor() {
        owner = msg.sender;
    }

    // function to allow users participate in lottery by sending ether
    function enter() public payable {
        // require that the user sends at least 0.01 ether
        require(msg.value > 0.01 ether, "Not enough ether");
        // add user's address to the ticketHolders array
        ticketHolders.push(payable(msg.sender));
    }

    // function to generate a random number
    function random() public view returns (uint256) {
    uint256 prevTimestamp = block.timestamp - 1;
    return uint256(keccak256(abi.encodePacked(prevTimestamp, block.timestamp, ticketHolders)));
    }

    // function to get number of ticket holders
    function getTicketHoldersCount() public view returns (uint256) {
        return ticketHolders.length;
    }

    // function to pick a winner randomly and transfer 1 ether to their address
    function pickWinner() public {
        // require that only the owner can pick a winner
        require(msg.sender == owner, "Only the owner can pick a winner");
        // generate a random index based on the number of ticket holders
        uint256 index = random() % ticketHolders.length;
        // transfer 1 ether to the winner's address
        ticketHolders[index].transfer(1 ether);
        // clear the ticketHolders array for the next cycle of the lottery
        delete ticketHolders;
    }
}
