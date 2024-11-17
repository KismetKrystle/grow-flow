// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GrowComponentNFT.sol";
import "./DiscountNFT.sol";
import "./OrderNFT.sol";

contract Marketplace {
    GrowComponentNFT public growComponentNFT;
    DiscountNFT public discountNFT;
    OrderNFT public orderNFT;

    mapping(uint256 => uint256) public prices;
    mapping(uint256 => bool) public isAvailable;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    event ItemPurchased(address buyer, uint256 componentID, uint256 finalPrice);

    constructor(address _growComponentNFT, address _discountNFT, address _orderNFT) {
        owner = msg.sender;
        growComponentNFT = GrowComponentNFT(_growComponentNFT);
        discountNFT = DiscountNFT(_discountNFT);
        orderNFT = OrderNFT(_orderNFT);
    }

    function setPrice(uint256 componentID, uint256 price) external onlyOwner {
        require(growComponentNFT.owners(componentID) == address(0), "Component must not be owned");
        prices[componentID] = price;
        isAvailable[componentID] = true;
    }

    function purchaseItem(uint256 componentID, uint256 discountID) external payable {
        require(isAvailable[componentID], "Component not available");
        uint256 price = prices[componentID];

        if (discountID > 0) {
            uint256 discount = discountNFT.applyDiscount(discountID, componentID);
            price = price - (price * discount / 10000);
        }

        require(msg.value >= price, "Insufficient funds");

        isAvailable[componentID] = false;
        growComponentNFT.transferComponent(componentID, msg.sender);
        orderNFT.mintOrderNFT(msg.sender, componentID, price);

        payable(owner).transfer(price);

        emit ItemPurchased(msg.sender, componentID, price);
    }
}
