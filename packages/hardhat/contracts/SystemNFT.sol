// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SystemNFT is ERC721URIStorage {
    address public owner;
    uint256 public nextTokenId = 1;

    struct SystemData {
        uint256 orderId; // Associated OrderNFT ID
        string upgrades; // Optional upgrades or additional data
    }

    mapping(uint256 => SystemData) public systems;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() ERC721("SystemNFT", "SNFT") {
        owner = msg.sender;
    }

    // Mint a SystemNFT after order is fulfilled
    function createSystemNFT(uint256 orderId, address buyer, string memory upgrades)
        public
        onlyOwner
    {
        systems[nextTokenId] = SystemData(orderId, upgrades);
        _mint(buyer, nextTokenId);
        nextTokenId++;
    }

    // Get system details
    function getSystemDetails(uint256 tokenId)
        public
        view
        returns (SystemData memory)
    {
        require(_exists(tokenId), "Token does not exist");
        return systems[tokenId];
    }
}
