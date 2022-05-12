const { expect } = require("chai");
const { ethers } = require("hardhat");
require("chai").should();

describe("ZombieFactory smart contract", () => {
  let ZombieFactory;
  let zombieFactory;
  let user1;
  let user2;

  beforeEach(async () => {
    ZombieFactory = await ethers.getContractFactory("ZombieFactory");
    [user1, user2] = await ethers.getSigners();

    zombieFactory = await ZombieFactory.deploy();
  });

  it("should create a zombie", async () => {
    await zombieFactory.createRandomZombie("Jad");
    const zombies = await zombieFactory.getZombies();
    // console.log(zombies);

    expect(zombies.length).to.equal(1);
    // zombies.length.should.equal(1);
  });

  it("should not be able to create 2 random zombies by the same user", async () => {
    await zombieFactory.connect(user1).createRandomZombie("Jad");

    await zombieFactory.connect(user2).createRandomZombie("Jad");
    const zombies = await zombieFactory.getZombies();
    expect(zombies.length).to.equal(2);

    await zombieFactory
      .connect(user2)
      .createRandomZombie("Jad")
      .should.be.revertedWith("You already have a zombie");
  });
});
