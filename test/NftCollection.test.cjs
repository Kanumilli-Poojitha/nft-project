const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NftCollection", function () {
  let NftCollection, nft, owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    NftCollection = await ethers.getContractFactory("NftCollection");
    nft = await NftCollection.deploy("MyNFT", "MNFT", 10, "https://example.com/");
    await nft.waitForDeployment();
  });

  it("should set the right owner", async function () {
    expect(await nft.owner()).to.equal(owner.address);
  });

  it("should mint a token", async function () {
    const tx = await nft.mint(addr1.address, "tokenURI1");
    await tx.wait();

    const tokenId = await nft.totalSupply(); // dynamically get latest token ID
    expect(await nft.ownerOf(tokenId)).to.equal(addr1.address);
  });

  it("should pause and unpause transfers", async function () {
    await nft.pause();

    // Minting while paused should fail
    await expect(nft.mint(addr1.address, "tokenURI2")).to.be.revertedWith(
      "Pausable: paused"
    );

    await nft.unpause();

    const tx = await nft.mint(addr1.address, "tokenURI2");
    await tx.wait();

    const tokenId = await nft.totalSupply(); // get the latest minted token ID dynamically
    expect(await nft.ownerOf(tokenId)).to.equal(addr1.address);
  });
});
