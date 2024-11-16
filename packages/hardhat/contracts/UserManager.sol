// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManager {
    address public owner;

    struct User {
        string username;
        address wallet;
        uint256[] ownedNFTs; // Array of owned NFT IDs
        uint256[] achievements; // Array of completed challenge IDs
        uint256 tokenBalance;
    }

    mapping(address => User) public users;
    mapping(address => bool) public isRegistered;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyRegisteredUser() {
        require(isRegistered[msg.sender], "User not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Register a new user
    function registerUser(string memory username) public {
        require(!isRegistered[msg.sender], "Already registered");
        User memory user;
        user.username = username;
        user.wallet = msg.sender;
        user.tokenBalance = 0;

        users[msg.sender] = user;
        // users[msg.sender] = User({
        //     username: username,
        //     wallet: msg.sender,
        //     ownedNFTs: new uint256,
        //   achievements: new uint256,
        //   tokenBalance: 0
        // });
        isRegistered[msg.sender] = true;
    }

    // Add an NFT to a user's profile
    function addNFTToUser(uint256 nftId) public onlyRegisteredUser {
        users[msg.sender].ownedNFTs.push(nftId);
    }

    // Track user achievements
    function addAchievement(uint256 achievementId) public onlyRegisteredUser {
        users[msg.sender].achievements.push(achievementId);
    }

    // Update token balance for a user
    function updateTokenBalance(uint256 amount, bool add) public onlyOwner {
        if (add) {
            users[msg.sender].tokenBalance += amount;
        } else {
            require(users[msg.sender].tokenBalance >= amount, "Insufficient balance");
            users[msg.sender].tokenBalance -= amount;
        }
    }

    // Get user profile
    function getUserProfile(address userAddress) 
        public 
        view 
        returns (User memory) 
    {
        require(isRegistered[userAddress], "User not registered");
        return users[userAddress];
    }
}
