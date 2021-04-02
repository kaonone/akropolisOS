// tslint:disable-next-line:no-reference
/// <reference path="global.d.ts" />

// Required by @openzeppelin/upgrades when running from truffle
global.artifacts = artifacts;
global.web3 = web3;

// Import dependencies from OpenZeppelin SDK programmatic library
// tslint:disable-next-line:no-var-requires
const { Contracts, SimpleProject, ZWeb3 } = require("@openzeppelin/upgrades")

async function main() {

  /* Initialize OpenZeppelin's Web3 provider. */
  ZWeb3.initialize(web3.currentProvider)

  /* Retrieve compiled contract artifacts. */
  // tslint:disable-next-line:variable-name
  const Counter_v0 = Contracts.getFromLocal("Counter_V0");
  // tslint:disable-next-line:variable-name
  const Counter_v1 = Contracts.getFromLocal("Counter_V1");

  /* Retrieve a couple of addresses to interact with the contracts. */
  const [creatorAddress, initializerAddress] = await ZWeb3.accounts();
  /* Create a SimpleProject to interact with OpenZeppelin programmatically. */
  const myProject = new SimpleProject("AkropolisOS", null, { from: creatorAddress });

  /* Deploy the contract with a proxy that allows upgrades. Initialize it by setting the value to 42. */
  const instance = await myProject.createProxy(Counter_v0, { initArgs: [1] })
  // tslint:disable-next-line:no-console
  console.log("Contract's storage value:", (await instance.methods.getCounter().call({ from: initializerAddress })).toString());

  /* Upgrade the contract at the address of our instance to the new logic, and initialize with a call to add. */
  await myProject.upgradeProxy(instance.address, Counter_v1, {  initMethod: "increaseCounter2", initArgs: [4] });
  // tslint:disable-next-line:no-console
  console.log("Contract's storage new value:", (await instance.methods.getCounter().call({ from: initializerAddress })).toString());
}

// For truffle exec
module.exports = function(callback: Function) {
  main().then(() => callback()).catch((err) => callback(err))
};
