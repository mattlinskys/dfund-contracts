import { ethers } from "hardhat";

async function main() {
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed at", factory.address);

  console.log("FUND token deployed at", await factory.fund());

  let tx = await factory.createProject("example-project", "Example project");
  await tx.wait();

  tx = await factory.createProfile("Matt");
  await tx.wait();

  const [account] = await ethers.getSigners();
  const address = await factory.profiles(account.address);
  console.log("Profile deployed at", address);

  const profile = await ethers.getContractAt("Profile", address);

  await profile.setAvatarUri("https://randomuser.me/api/portraits/men/22.jpg");

  console.log("Profile name", await profile.name());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
