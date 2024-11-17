// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GrowComponentNFT {
    struct Component {
        uint256 id;
        string metadata;
    }

    mapping(uint256 => Component) public components;
    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;

    uint256 public nextComponentID;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mintComponent(address to, string memory metadata) external onlyOwner {
        uint256 componentID = nextComponentID++;
        owners[componentID] = to;
        balances[to]++;

        components[componentID] = Component({
            id: componentID,
            metadata: metadata
        });
    }

    function transferComponent(uint256 componentID, address to) external {
        require(owners[componentID] == msg.sender, "Not the owner of this component");

        address currentOwner = owners[componentID];
        balances[currentOwner]--;
        balances[to]++;
        owners[componentID] = to;
    }

    function burnComponent(uint256 componentID) external onlyOwner {
        address tokenOwner = owners[componentID];
        require(tokenOwner != address(0), "Invalid component ID");

        delete components[componentID];
        delete owners[componentID];
        balances[tokenOwner]--;
    }
}
