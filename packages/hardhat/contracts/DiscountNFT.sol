// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DiscountNFT is ERC721, Ownable {

    // Structure to hold details for each DiscountNFT
    struct Discount {
        uint256 discountValue;    // Discount value as a percentage (e.g., 500 for 5%)
        uint256 associatedComponentID; // ID of the associated GrowComponentNFT
        bool isUsed; // To track if the discount has been applied
    }

    // Mapping from DiscountNFT ID to Discount data
    mapping(uint256 => Discount) public discounts;

    uint256 public nextDiscountID; // To track the next DiscountNFT ID

    // Event to emit when a discount is applied
    event DiscountApplied(uint256 discountID, uint256 componentID, uint256 discountValue, address user);

    // Constructor
    constructor() ERC721("DiscountNFT", "DNFT") {}

    // Function to mint a new DiscountNFT
    function mintDiscountNFT(address to, uint256 discountValue, uint256 associatedComponentID) external onlyOwner {
        uint256 discountID = nextDiscountID;
        _mint(to, discountID);

        // Store the discount data
        discounts[discountID] = Discount({
            discountValue: discountValue,
            associatedComponentID: associatedComponentID,
            isUsed: false
        });

        nextDiscountID = nextDiscountID.add(1);
    }

    function _exists(uint256 discountID) public view returns(bool) {
        return discountID > 0;
    }

    // Function to apply discount to a purchase (e.g., GrowComponentNFT)
    function applyDiscount(uint256 discountID, uint256 componentID) external returns (uint256) {
        // Ensure the DiscountNFT exists and is not used
        require(_exists(discountID), "DiscountNFT does not exist");
        require(discounts[discountID].isUsed == false, "Discount already used");

        // Ensure that the discount is applied to the correct GrowComponentNFT
        require(discounts[discountID].associatedComponentID == componentID, "Discount can only be applied to the associated component");

        // Mark the discount as used
        discounts[discountID].isUsed = true;

        // Calculate the discount amount and apply it to the price (percentage-based)
        uint256 discountValue = discounts[discountID].discountValue;
        emit DiscountApplied(discountID, componentID, discountValue, msg.sender);

        // Return the discount value that can be used to reduce the total price (in cents or a smaller unit)
        return discountValue;
    }

    // Function to check the discount details
    function getDiscountDetails(uint256 discountID) external view returns (uint256 discountValue, uint256 associatedComponentID, bool isUsed) {
        require(_exists(discountID), "DiscountNFT does not exist");
        Discount memory discount = discounts[discountID];
        return (discount.discountValue, discount.associatedComponentID, discount.isUsed);
    }

    // Function to destroy a DiscountNFT after it has been used
    function burnDiscountNFT(uint256 discountID) external onlyOwner {
        require(_exists(discountID), "DiscountNFT does not exist");
        _burn(discountID);
    }
}

