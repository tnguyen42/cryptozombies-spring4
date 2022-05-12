const { expect } = require("chai");
const { ethers } = require("hardhat");
require("chai").should();

describe("ZombieFeeding smart contract", () => {
  let ZombieFeeding;
  let zombieFeeding;
  let owner;
  let user2;

  beforeEach(async () => {
    [owner, user2] = await ethers.getSigners();
    ZombieFeeding = await ethers.getContractFactory("ZombieFeeding");

    zombieFeeding = await ZombieFeeding.connect(owner).deploy();
  });

  it.skip("Only the owner should be able to set the CryptoKitties smart contract", async () => {
    await zombieFeeding.connect(owner).setKittyContractAddress("0x000000");

    await zombieFeeding
      .connect(user2)
      .setKittyContractAddress("0x000000")
      .should.be.revertedWith("Ownable: caller is not the owner");
  });
});
