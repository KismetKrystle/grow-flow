// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract GrowComponentNFT is ERC721URIStorage {
    address public owner; // Contract owner
    uint256 public nextTokenId = 1;

    struct ComponentData {
        string name;
        string description;
        string specs;
        uint256 price; // Price in Wei
        bool availableForPurchase;
    }

    mapping(uint256 => ComponentData) public components;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() ERC721("GrowComponentNFT", "GCNFT") {
        owner = msg.sender;
    }

    // Add a new grow component
    function addGrowComponent(
        string memory _name,
        string memory _description,
        string memory _specs,
        uint256 _price
    ) public onlyOwner {
        components[nextTokenId] = ComponentData(
            _name,
            _description,
            _specs,
            _price,
            true
        );
        _mint(owner, nextTokenId);
        nextTokenId++;
    }

    // Retrieve component details
    function getComponentDetails(uint256 tokenId)
        public
        view
        returns (ComponentData memory)
    {
        require(_exists(tokenId), "Token does not exist");
        return components[tokenId];
    }

    function _exists(uint256 discountID) public view returns(bool) {
        return discountID > 0;
    }

    // Disable availability for purchase
    function setPurchaseAvailability(uint256 tokenId, bool status) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        components[tokenId].availableForPurchase = status;
    }

    // Prevent transfers
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal pure override {
        require(false, "Transfer not allowed");
    }
}

