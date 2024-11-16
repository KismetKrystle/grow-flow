async function main() {
    // Fetch the accounts
    const [deployer] = await ethers.getSigners();
    
    console.log('Deploying contracts with the account:', deployer.address);
  
    // Deploy the DiscountNFT contract
    const DiscountNFT = await ethers.getContractFactory('DiscountNFT');
    const discountNFT = await DiscountNFT.deploy();
  
    console.log('DiscountNFT contract deployed to:', discountNFT.address);
  }
  
  // Run the main function
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  