// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GrowSystemNFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;
    mapping(uint256 => uint256) public productPrices; // Mapping of tokenId to product price
    mapping(uint256 => string) public productImages; // Mapping of tokenId to product image
    mapping(uint256 => string) public projectDescriptions; // Mapping of tokenId to project description
    mapping(uint256 => uint256) public peopleFed; // Mapping of tokenId to number of people fed
    mapping(uint256 => uint256) public plantsGrown; // Mapping of tokenId to number of plants grown

    event FundsTransferred(address indexed buyer, uint256 amount, uint256 tokenId);
    event NFTMinted(uint256 tokenId, string tokenURI);

    constructor() ERC721("GrowSystemNFT", "GSNFT") {
        tokenCounter = 0;
    }

    // Function to approve the purchase and mint the NFT
    function approvePurchase(
        uint256 price,
        string memory productImage,
        string memory description,
        uint256 people,
        uint256 plants
    ) public payable {
        require(msg.value >= price, "Insufficient funds sent");
        
        // Increment token counter and mint the NFT
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        
        // Store metadata
        productPrices[newTokenId] = price;
        productImages[newTokenId] = productImage;
        projectDescriptions[newTokenId] = description;
        peopleFed[newTokenId] = people;
        plantsGrown[newTokenId] = plants;

        // Set token URI (metadata)
        string memory tokenURI = generateTokenURI(newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        // Emit event for funds transfer
        emit FundsTransferred(msg.sender, msg.value, newTokenId);
        emit NFTMinted(newTokenId, tokenURI);

        // Output message (this would typically be handled off-chain)
        // In a real application, you would use events to notify the frontend
    }

    // Function to generate token URI (metadata)
    function generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        // Here you would typically return a JSON string or a link to a metadata file
        // For simplicity, we will return a simple string
        return string(abi.encodePacked(
            "{",
            '"name": "Grow System NFT #', uint2str(tokenId), '",',
            '"description": "', projectDescriptions[tokenId], '",',
            '"image": "', productImages[tokenId], '",',
            '"peopleFed": ', uint2str(peopleFed[tokenId]), ',',
            '"plantsGrown": ', uint2str(plantsGrown[tokenId]),
            "}"
        ));
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
