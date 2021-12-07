import { ethers } from "hardhat";

async function main() {
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed at", factory.address);

  console.log("FUND token deployed at", await factory.fund());

  // const [account] = await ethers.getSigners();

  // let tx = await factory.createProject(
  //   ethers.utils.hexZeroPad(ethers.utils.toUtf8Bytes("example-project"), 32),
  //   ethers.utils.hexZeroPad(ethers.utils.toUtf8Bytes("Example project"), 32)
  // );
  // await tx.wait();

  // const projectAddress = await factory.projects(
  //   ethers.utils.hexZeroPad(ethers.utils.toUtf8Bytes("example-project"), 32)
  // );
  // console.log("Project deployed at", projectAddress);

  // const project = await ethers.getContractAt("Project", projectAddress);
  // await project.setCustomKey(
  //   ethers.utils.keccak256(ethers.utils.toUtf8Bytes("bannerUri")),
  //   "https://via.placeholder.com/1200x360"
  // );

  // tx = await factory.createProfile("Matt");
  // await tx.wait();

  // const address = await factory.profiles(account.address);
  // console.log("Profile deployed at", address);

  // const profile = await ethers.getContractAt("Profile", address);

  // console.log(
  //   "Profile name",
  //   await profile.customKeys(
  //     ethers.utils.keccak256(ethers.utils.toUtf8Bytes("name"))
  //   )
  // );

  // await profile.setCustomKey(
  //   ethers.utils.keccak256(ethers.utils.toUtf8Bytes("avatarUri")),
  //   "http://test.te"
  // );

  // console.log(
  //   "Profile avatar URI",
  //   await profile.customKeys(
  //     ethers.utils.keccak256(ethers.utils.toUtf8Bytes("avatarUri"))
  //   )
  // );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
