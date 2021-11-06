// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import hre from "hardhat";

const ctoAddress_Ropsten = "0x1CeE94a11eAf390B67Aa346E9Dda3019DfaD4f6A";
const ctoAddress_Mainnet = "0xa5e48a6E56e164907263e901B98D9b11CCB46C47";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const CoinversationToken = await ethers.getContractFactory("CoinversationToken");
  const cto = await CoinversationToken.deploy(13566600);

  await cto.deployed();

  console.log("CTO deployed to:", cto.address);

  // await sleep(60000);

  // await hre.run("verify:verify", {
  //   address: ctoAddress_Mainnet,
  //   contract: "contracts/CoinversationToken.sol:CoinversationToken",
  //   constructorArguments: [13566600]
  // });
}

function sleep(ms:number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
