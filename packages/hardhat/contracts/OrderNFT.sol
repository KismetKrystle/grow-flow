// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderNFT {
    struct Order {
        uint256 orderID;
        uint256 componentID;
        uint256 price;
    }

    mapping(uint256 => Order) public orders;
    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;

    uint256 public nextOrderID;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mintOrderNFT(address to, uint256 componentID, uint256 price) external onlyOwner {
        uint256 orderID = nextOrderID++;
        owners[orderID] = to;
        balances[to]++;

        orders[orderID] = Order({
            orderID: orderID,
            componentID: componentID,
            price: price
        });
    }

    function burnOrderNFT(uint256 orderID) external onlyOwner {
        address tokenOwner = owners[orderID];
        require(tokenOwner != address(0), "Invalid order ID");

        delete orders[orderID];
        delete owners[orderID];
        balances[tokenOwner]--;
    }
}