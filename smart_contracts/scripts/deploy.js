const { ethers } = require("hardhat");
// async function main() to simultaneously deploy all three smart contracts in the collection

async function main() {
  const [deployer] = await ethers.getSigners();
  
// Deploy DeliveryEscrow.sol
  console.log('Deploying DeliveryEscrow from account:', deployer.address);
  const DeliveryEscrow = await ethers.getContractFactory("DeliveryEscrow");
  const amount = ethers.utils.parseUnits("1", "wei").mul(ethers.BigNumber.from(10).pow(15)).toString();
  const deliveryEscrow = await DeliveryEscrow.deploy(    
    '0x92219f351d2eD621AFAF70004cc3aB985fC2bD07', // buyer's address.
    '0x4076D1614357208C73AA620E7aAD09B17FEc59Ad', // seller's address.
    amount  // amount of eth i.e., 1/1000 (1e15 or "1000000000000" or 1 wei * 10^15) ethers
  );
  await deliveryEscrow.deployed()
  console.log("DeliveryEscrow deployed to:", deliveryEscrow.address);

// Deploy Lottery.sol
  console.log('Deploying Lottery from account:', deployer.address);
  const Lottery = await ethers.getContractFactory("Lottery");
  const lottery = await Lottery.deploy();
  await lottery.deployed()
  console.log("Lottery deployed to:", lottery.address);

// Deploy MyToken.sol
console.log('Deploying MyToken from account:', deployer.address);
const MyToken = await ethers.getContractFactory("MyToken", deployer);
const myToken = await MyToken.deploy(1000);
await myToken.deployed()
console.log("MyToken deployed to:", myToken.address);

console.log("Sleeping.....");
  // Wait for block explorer to notice that the contract has been deployed
  await sleep(10000);


  // Verify the MyToken contract after deploying
  await hre.run("verify:verify", {
    contract: "contracts/MyToken.sol:MyToken",
    address: myToken.address,
    constructorArguments: [1000],
  });
  console.log("Verified MyToken ")


  // Verify the DeliveryEscrow contract after deploying
  await hre.run("verify:verify", {
    contract: "contracts/DeliveryEscrow.sol:DeliveryEscrow",
    address: deliveryEscrow.address,
    constructorArguments: ['0x92219f351d2eD621AFAF70004cc3aB985fC2bD07', '0x4076D1614357208C73AA620E7aAD09B17FEc59Ad', amount],
  });
  console.log("Verified DeliveryEscrow ")


  // Verify the Lottery contract after deploying
  await hre.run("verify:verify", {
    contract: "contracts/Lottery.sol:Lottery",
    address: lottery.address,
    constructorArguments: [],
  });
  console.log("Verified Lottery ")


}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


  /// npx hardhat run scripts/deploy.js --network mumbai
