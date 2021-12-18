const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hangman", function () {
  it("Should create and execute a simple game of hangman", async function () {
    console.log("-----------------------------------------------------------");
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("abc", 2);
    await hangman.deployed();

    expect(await hangman.solution()).to.equal("___");
    const makeGuessTx = await hangman.makeGuess("a");
    await makeGuessTx.wait();

    expect(await hangman.solution()).to.equal("a__");
    const makeGuessTx2 = await hangman.makeGuess("b");
    await makeGuessTx2.wait();

    const makeGuessTx3 = await hangman.makeGuess("c");
    await makeGuessTx3.wait();

    expect(await hangman.solution()).to.equal("abc");
    expect(await hangman.lives()).to.equal(2);
  });

  it("Should create and execute a loss while playing hangman", async function() {
    console.log("-----------------------------------------------------------");
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("abc", 1);
    await hangman.deployed();

    const makeGuessTx = await hangman.makeGuess("f");
    await makeGuessTx.wait();

    expect(await hangman.lives()).to.equal(0);
  });

  it("Should create and execute illegal moves while playing hangman", async function() {
    console.log("-----------------------------------------------------------");
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("abc", 1);
    await hangman.deployed();

    const makeGuessTx = await hangman.makeGuess("f");
    await makeGuessTx.wait();

    expect(await hangman.lives()).to.equal(0);

    await expect(hangman.makeGuess("f")).to.be.reverted;
    await expect(hangman.makeGuess("alksjdf")).to.be.reverted;
    await expect(hangman.makeGuess("a")).to.be.reverted;
  });

  it("Standard game, check for repeated characters", async function() {
    console.log("-----------------------------------------------------------");
    const Hangman = await ethers.getContractFactory("Hangman");
    const hangman = await Hangman.deploy("abba", 10);
    await hangman.deployed();

    expect(await hangman.solution()).to.equal("____");

    const makeGuessTx = await hangman.makeGuess("a");
    await makeGuessTx.wait();
    expect(await hangman.solution()).to.equal("a__a");

  });
});
