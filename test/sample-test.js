const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hangman", function () {
  it("Should create and execute a simple game of hangman", async function () {
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("abc", 2);
    await hangman.deployed();

    expect(await hangman.solution()).to.equal("___");

    const makeGuessTx = await hangman.makeGuess("a");

    // wait until the transaction is mined
    await makeGuessTx.wait();

    expect(await hangman.solution()).to.equal("a__");

    const makeGuessTx2 = await hangman.makeGuess("b");
    await makeGuessTx2.wait();

    const makeGuessTx3 = await hangman.makeGuess("c");
    await makeGuessTx3.wait();

    expect(await hangman.solution()).to.equal("abc");
  });
});
