const hre = require("hardhat");

async function main() {
  // Deploy GrowComponentNFT
  const GrowComponentNFT = await hre.ethers.getContractFactory("GrowComponentNFT");
  const growComponentNFT = await GrowComponentNFT.deploy();
  await growComponentNFT.deployed();
  console.log("GrowComponentNFT deployed to:", growComponentNFT.address);

  // Deploy DiscountNFT
  const DiscountNFT = await hre.ethers.getContractFactory("DiscountNFT");
  const discountNFT = await DiscountNFT.deploy();
  await discountNFT.deployed();
  console.log("DiscountNFT deployed to:", discountNFT.address);

  // Deploy OrderNFT
  const OrderNFT = await hre.ethers.getContractFactory("OrderNFT");
  const orderNFT = await OrderNFT.deploy();
  await orderNFT.deployed();
  console.log("OrderNFT deployed to:", orderNFT.address);

  // Deploy Marketplace
  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy(
    growComponentNFT.address,
    discountNFT.address,
    orderNFT.address
  );
  await marketplace.deployed();
  console.log("Marketplace deployed to:", marketplace.address);

  // Optionally, set initial configurations (example: setting prices)
  const componentID = 1; // Example component ID
  const price = ethers.utils.parseEther("0.01"); // Example price in ETH
  await growComponentNFT.mintComponent(marketplace.address, "Initial Metadata");
  await marketplace.setPrice(componentID, price);
  console.log(`Component ${componentID} price set to ${price}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
