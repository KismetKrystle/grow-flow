// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./GrowComponentNFT.sol"; // Importing the GrowComponentNFT contract
import "./DiscountNFT.sol"; // Importing the DiscountNFT contract
import "./OrderNFT.sol"; // Importing the OrderNFT contract

contract Marketplace is ERC721, Ownable {

    // References to the external contracts for GrowComponentNFT, DiscountNFT, and OrderNFT
    GrowComponentNFT public growComponentNFT;
    DiscountNFT public discountNFT;
    OrderNFT public orderNFT;

    // Struct to hold marketplace item details
    struct MarketplaceItem {
        uint256 componentID;         // ID of the GrowComponentNFT
        uint256 price;               // Price of the GrowComponentNFT
        bool isAvailable;            // Whether the item is available for purchase
    }

    // Mapping from componentID to marketplace item
    mapping(uint256 => MarketplaceItem) public marketplaceItems;

    // Mapping for tracking the next OrderNFT ID
    uint256 public nextOrderID;

    // Event emitted when a purchase is made
    event PurchaseMade(address indexed buyer, uint256 indexed componentID, uint256 price, uint256 orderID);

    // Constructor
    constructor(address _growComponentNFT, address _discountNFT, address _orderNFT) ERC721("Marketplace", "MPNFT") {
        growComponentNFT = GrowComponentNFT(_growComponentNFT);
        discountNFT = DiscountNFT(_discountNFT);
        orderNFT = OrderNFT(_orderNFT);
    }

    // Function to add a GrowComponentNFT to the marketplace
    function addItemToMarketplace(uint256 componentID, uint256 price) external onlyOwner {
        require(growComponentNFT._exists(componentID), "Component does not exist");
        marketplaceItems[componentID] = MarketplaceItem({
            componentID: componentID,
            price: price,
            isAvailable: true
        });
    }

    // Function to remove an item from the marketplace
    function removeItemFromMarketplace(uint256 componentID) external onlyOwner {
        marketplaceItems[componentID].isAvailable = false;
    }

    // Function to apply a DiscountNFT and return the adjusted price
    function applyDiscount(uint256 discountID, uint256 componentID) internal returns (uint256) {
        uint256 discountValue = discountNFT.applyDiscount(discountID, componentID); // Apply discount
        uint256 originalPrice = marketplaceItems[componentID].price;
        uint256 discountedPrice = originalPrice.sub(originalPrice.mul(discountValue).div(10000)); // Applying percentage discount
        return discountedPrice;
    }

    // Function to purchase a GrowComponentNFT
    function purchaseGrowComponent(uint256 componentID, uint256 discountID) external payable {
        require(marketplaceItems[componentID].isAvailable, "Item not available");
        uint256 priceAfterDiscount = applyDiscount(discountID, componentID);

        require(msg.value >= priceAfterDiscount, "Insufficient funds");

        // Issue OrderNFT to the buyer
        uint256 orderID = nextOrderID;
        nextOrderID = nextOrderID.add(1);
        orderNFT.mintOrderNFT(msg.sender, componentID, priceAfterDiscount, orderID);

        // Emit an event for the purchase
        emit PurchaseMade(msg.sender, componentID, priceAfterDiscount, orderID);

        // Transfer the funds to the marketplace owner
        payable(owner()).transfer(msg.value);
    }

    // Function to upgrade an OrderNFT to a SystemNFT after the product is received
    function upgradeToSystemNFT(uint256 orderID) external {
        require(orderNFT.ownerOf(orderID) == msg.sender, "You must own the OrderNFT to upgrade");
        uint256 componentID = orderNFT.getComponentID(orderID);

        // Burn the OrderNFT and mint the SystemNFT
        orderNFT.burnOrderNFT(orderID);
        growComponentNFT.upgradeToSystemNFT(componentID, msg.sender);

        // Emit an event for the upgrade
        emit UpgradeToSystemNFT(msg.sender, componentID, orderID);
    }

    // Event emitted when an OrderNFT is upgraded to a SystemNFT
    event UpgradeToSystemNFT(address indexed buyer, uint256 indexed componentID, uint256 indexed orderID);
}
