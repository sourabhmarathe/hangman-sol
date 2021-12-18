const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hangman", function () {
  it("Should create and execute a simple game of hangman", async function () {
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("")
    await hangman.deployed();

    expect(await hangman.solution()).to.equal("___");

    //const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
