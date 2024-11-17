const ethers = hre.ethers;

async function main() {
  // Contract addresses (replace these with deployed addresses)
  const marketplaceAddress = "0xMarketplaceAddress";
  const growComponentNFTAddress = "0xGrowComponentNFTAddress";
  const discountNFTAddress = "0xDiscountNFTAddress";
  const orderNFTAddress = "0xOrderNFTAddress";

  // Load the contract ABIs
  const Marketplace = await hre.ethers.getContractFactory("Marketplace");
  const GrowComponentNFT = await hre.ethers.getContractFactory("GrowComponentNFT");
  const DiscountNFT = await hre.ethers.getContractFactory("DiscountNFT");
  const OrderNFT = await hre.ethers.getContractFactory("OrderNFT");

  // Connect to the deployed contracts
  const marketplace = Marketplace.attach(marketplaceAddress);
  const growComponentNFT = GrowComponentNFT.attach(growComponentNFTAddress);
  const discountNFT = DiscountNFT.attach(discountNFTAddress);
  const orderNFT = OrderNFT.attach(orderNFTAddress);

  // User Interaction Example:

  // 1. View Available Components
  console.log("Fetching available components...");
  const componentID = 1; // Example component ID
  const price = await marketplace.getPrice(componentID);
  console.log(`Component ${componentID} is available for: ${ethers.utils.formatEther(price)} ETH`);

  // 2. Apply Discount (Optional)
  const discountID = 1; // Replace with the user's discount ID
  try {
    const discountedPrice = await marketplace.connect(await hre.ethers.getSigner()).applyDiscount(discountID, componentID);
    console.log(`Discount applied! New price is: ${ethers.utils.formatEther(discountedPrice)} ETH`);
  } catch (error) {
    console.log("No valid discount applied or discount not needed.");
  }

  // 3. Purchase Component
  const purchasePrice = price; // Replace with `discountedPrice` if a discount is applied
  const tx = await marketplace.purchaseGrowComponent(componentID, discountID, {
    value: purchasePrice, // Sending ETH as payment
  });
  await tx.wait();
  console.log(`Component ${componentID} purchased successfully! Transaction hash: ${tx.hash}`);

  // 4. Upgrade OrderNFT to SystemNFT
  const orderID = 1; // Replace with the user's OrderNFT ID
  const upgradeTx = await marketplace.upgradeToSystemNFT(orderID);
  await upgradeTx.wait();
  console.log(`OrderNFT ${orderID} upgraded to SystemNFT successfully! Transaction hash: ${upgradeTx.hash}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
