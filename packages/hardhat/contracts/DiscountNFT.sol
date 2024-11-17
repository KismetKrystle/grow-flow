// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DiscountNFT {
    struct Discount {
        uint256 discountValue;       // Discount percentage (e.g., 500 for 5%)
        uint256 associatedComponentID; // Associated GrowComponentNFT ID
        bool isUsed;                // If the discount is applied
    }

    mapping(uint256 => Discount) public discounts;
    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;

    uint256 public nextDiscountID;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    event DiscountApplied(uint256 discountID, uint256 componentID, uint256 discountValue, address user);

    constructor() {
        owner = msg.sender;
    }

    function mintDiscountNFT(address to, uint256 discountValue, uint256 associatedComponentID) external onlyOwner {
        uint256 discountID = nextDiscountID++;
        owners[discountID] = to;
        balances[to]++;

        discounts[discountID] = Discount({
            discountValue: discountValue,
            associatedComponentID: associatedComponentID,
            isUsed: false
        });
    }

    function applyDiscount(uint256 discountID, uint256 componentID) external returns (uint256) {
        require(owners[discountID] == msg.sender, "Not the owner of this discount");
        require(!discounts[discountID].isUsed, "Discount already used");
        require(discounts[discountID].associatedComponentID == componentID, "Invalid component ID");

        discounts[discountID].isUsed = true;
        emit DiscountApplied(discountID, componentID, discounts[discountID].discountValue, msg.sender);

        return discounts[discountID].discountValue;
    }

    function burnDiscountNFT(uint256 discountID) external onlyOwner {
        address tokenOwner = owners[discountID];
        require(tokenOwner != address(0), "Invalid discount ID");

        delete discounts[discountID];
        delete owners[discountID];
        balances[tokenOwner]--;
    }
}