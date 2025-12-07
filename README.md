 NFT Project:

This project is a simple NFT collection using Solidity, Hardhat, and OpenZeppelin. It supports minting, burning, pausing/unpausing transfers, and is fully tested with Hardhat.

 Prerequisites

- Node.js v18.20.0 (used in Docker and tested)

- npm
- Docker (optional, for containerized testing)

---

 Project Setup

1. Clone the repository

git clone <https://github.com/Kanumilli-Poojitha/nft-project>
cd nft-project

2. Install dependencies
npm install --legacy-peer-deps

3. Compile Contracts
npx hardhat compile

4. Run Tests Locally
npx hardhat test

All tests should pass:

Setting the correct owner

Minting tokens

Pausing and unpausing transfers

* Using Docker

1. Build Docker image

docker build -t nft-contract .

2. Run the container
docker run nft-contract

Project Structure

nft-project/
├── contracts/
│   └── NftCollection.sol
├── test/
│   └── NftCollection.test.cjs
├── package.json
├── package-lock.json
├── hardhat.config.cjs
├── Dockerfile
├── .dockerignore
└── README.md
