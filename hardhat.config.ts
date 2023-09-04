import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-contract-sizer";
import "hardhat-abi-exporter";
import "hardhat-gas-reporter";
import * as dotenv from "dotenv";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const {} = process.env;

const {
  BSC_TESTNET_PRIVATE_KEY: bscTestnetPrivateKey,
  BSC_MAINNET_PRIVATE_KEY: bscMainnetPrivateKey,
  OP_BNB_TESTNET_PRIVATE_KEY: opTestnetPrivateKey,
  OP_BNB_MAINNET_PRIVATE_KEY: opMainnetPrivateKey,
} = process.env;
const reportGas = process.env.REPORT_GAS;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    "bsc:testnet": {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      gasPrice: 5000000000,
      accounts: [bscTestnetPrivateKey],
      timeout: 2_147_483_647,
    },
    "bsc:mainnet": {
      url: "https://bsc-dataseed1.binance.org/",
      chainId: 56,
      gasPrice: 3000000000,
      accounts: [bscMainnetPrivateKey],
      timeout: 2_147_483_647,
    },
    "opBNB:testnet": {
      url: "https://opbnb-testnet-rpc.bnbchain.org",
      chainId: 5611,
      gasPrice: 1000000000,
      accounts: [opTestnetPrivateKey],
      timeout: 2_147_483_647,
    },
    "opBNB:mainnet": {
      url: "TBD",
      chainId: 0,
      gasPrice: 1000000000,
      accounts: [opMainnetPrivateKey],
      timeout: 2_147_483_647,
    },
  },
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  abiExporter: {
    path: "data/abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    only: [],
    spacing: 4,
  },
  gasReporter: {
    enabled: reportGas == "1",
  },
  etherscan: {
    apiKey: {
      "eth:mainnet": "",
    },
    customChains: [
      {
        network: "eth:mainnet",
        chainId: 1,
        urls: {
          apiURL: "https://api.etherscan.io/api",
          browserURL: "https://etherscan.io",
        },
      },
    ],
  },
  mocha: {
    timeout: 20000,
  },
};
