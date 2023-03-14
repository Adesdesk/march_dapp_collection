// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Define a contract called DeliveryEscrow
contract DeliveryEscrow {
    // Defining state variables that get stored on-chain
    address public buyer;   // Ethereum address of a buyer
    address public seller;  // Ethereum address of a seller
    uint public amount;     // Amount held in the delivery escrow
    bool public delivered;  // An indicator whether or not, the product has been delivered

    // Defining a constructor function that gets called when the contract is deployed
    constructor(address _buyer, address _seller, uint _amount) payable {
        buyer = _buyer;     // set buyer's address
        seller = _seller;   // set seller's address
        amount = _amount;   // set amount of funds to be held in the delivery escrow
    }

    // Defining a function that allows a buyer confirm that product has been delivered
    function confirmDelivery() public {
        // Require that the caller of this function is same as the buyer
        require(msg.sender == buyer, "Only the buyer can confirm successful delivery");
        delivered = true;   // set the delivered indicator to true
    }

    // Defining a function that allows a seller release funds from the delivery escrow
    function releasePayment() public {
        // Require that product has been delivered accordingly
        require(delivered, "Payment can only be released after product gets delivered");
        // Require that the caller of this function is same as the seller
        require(msg.sender == seller, "Only the seller can approve release of payment");
        payable(seller).transfer(amount);  // Transfer funds to seller's address
    }

    // Defining a function that allows a buyer request a refund
    function refundPayment() public {
        // Require that product has not been delivered
        require(!delivered, "Payment can only be refunded if product is not delivered");
        // Require that the caller of this function is same as the buyer
        require(msg.sender == buyer, "Only the buyer can trigger a refund");
        payable(buyer).transfer(amount);   // Transfer held funds back to buyer's address
    }
}
