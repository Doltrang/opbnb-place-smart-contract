import "@nomiclabs/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";
import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account: ", owner.address);
  console.log("Account balance: ", (await owner.getBalance()).toString());
  const beneficary = owner.address;

  // Deploy
  const OpBNBPlace = await ethers.deployContract("OpBNBPlace");
  await OpBNBPlace.initialize(beneficary);
  console.log("OpBNBPlace is deployed at: ", OpBNBPlace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
