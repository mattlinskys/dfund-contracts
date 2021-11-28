import { expect } from "chai";
import { ethers } from "hardhat";
import type { ContractTransaction } from "ethers";

describe("Factory", function () {
  it("Should create new project contract", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    const tx = await factory.createProject("test");
    await tx.wait();

    const address = await factory.projects("test");

    expect(address).to.not.equal(ethers.constants.AddressZero);

    const project = await ethers.getContractAt("Project", address);
    expect(await project.slug()).to.equal("test");

    const [signer] = await ethers.getSigners();

    // project.connect(signer)

    const isAdmin = await project.hasRole(
      ethers.constants.HashZero,
      signer.address
    );
    expect(isAdmin).to.equal(true);
  });

  it("Should throw when duplicate slug is used while creating new project contract", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    let tx = await factory.createProject("test");
    await tx.wait();

    await expect(factory.createProject("test")).to.be.revertedWith(
      "VM Exception while processing transaction: reverted with reason string 'Project slug is already taken'"
    );
  });

  it("Should create new profile contract", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    const tx: ContractTransaction = await factory.createProfile("john");
    await tx.wait();

    const [signer] = await ethers.getSigners();

    const address = await factory.profiles(signer.address);

    expect(address).to.not.equal(ethers.constants.AddressZero);

    const profile = await ethers.getContractAt("Profile", address);

    expect(await profile.name()).to.equal("john");
  });
});
