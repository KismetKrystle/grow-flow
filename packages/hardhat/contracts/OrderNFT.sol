// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract OrderNFT is ERC721URIStorage {
    address public owner;
    uint256 public nextTokenId = 1;

    struct OrderData {
        uint256 componentId; // ID of the GrowComponentNFT
        address buyer;
        bool fulfilled;
    }

    mapping(uint256 => OrderData) public orders;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() ERC721("OrderNFT", "ONFT") {
        owner = msg.sender;
    }

    // Issue an OrderNFT
    function createOrderNFT(uint256 componentId, address buyer)
        public
        onlyOwner
        returns (uint256)
    {
        orders[nextTokenId] = OrderData(componentId, buyer, false);
        _mint(buyer, nextTokenId);
        nextTokenId++;
        return nextTokenId - 1;
    }

    // Mark order as fulfilled
    function fulfillOrder(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        orders[tokenId].fulfilled = true;
    }

    // Get order details
    function getOrderDetails(uint256 tokenId)
        public
        view
        returns (OrderData memory)
    {
        require(_exists(tokenId), "Token does not exist");
        return orders[tokenId];
    }