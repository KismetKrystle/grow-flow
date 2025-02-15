require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {},
    goerli: {
      url: "https://eth-goerli.alchemyapi.io/v2/YOUR_ALCHEMY_KEY",
      accounts: ["YOUR_PRIVATE_KEY"]
    }
  }
};

import '@nomicfoundation/hardhat-toolbox';
import '@nomicfoundation/hardhat-verify';
import { config as dotEnvConfig } from 'dotenv';
import { HardhatUserConfig } from 'hardhat/config';

dotEnvConfig();

const config: HardhatUserConfig = {
  networks: {
    alfajores: {
      accounts: [process.env.PRIVATE_KEY ?? '0x0'],
      url: 'https://alfajores-forno.celo-testnet.org',
    },
    celo: {
      accounts: [process.env.PRIVATE_KEY ?? '0x0'],
      url: 'https://forno.celo.org',
    },
    flowTestnet: {
      accounts: [process.env.PRIVATE_KEY ?? '0x0'],
      url: 'https://testnet.evm.nodes.onflow.org',
    },
  },
  etherscan: {
    apiKey: {
      alfajores: process.env.CELOSCAN_API_KEY ?? '',
      celo: process.env.CELOSCAN_API_KEY ?? '',
    },
    customChains: [
      {
        chainId: 44_787,
        network: 'alfajores',
        urls: {
          apiURL: 'https://api-alfajores.celoscan.io/api',
          browserURL: 'https://alfajores.celoscan.io',
        },
      },
      {
        chainId: 42_220,
        network: 'celo',
        urls: {
          apiURL: 'https://api.celoscan.io/api',
          browserURL: 'https://celoscan.io/',
        },
      },
      {
        chainId: 545,
        network: 'flowTestnet',
        urls: {
          apiURL: 'https://evm-testnet.flowscan.io/api',
          browserURL: 'https://evm-testnet.flowscan.io',
        },
      },
    ],
  },
  sourcify: {
    enabled: false,
  },
  solidity: '0.8.24',
};

export default config;