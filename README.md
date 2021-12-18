# Hangman on the blockchain

This is a basic implementation of the game HANGMAN in Solidity. It uses 
Ethereum or any EVM compatible blockchain as its backend. It's exactly
like any other Hangman game except it costs money to play.

To create a game, deploy a transaction of this contract with the secret
and number of lives you wish to grant the guesser. From there, the
guesser can call the external method "makeGuess" until he runs out of
lives or guesses the entire word. Additionally, users can call the
"currentSolution" and "guessesMade" functions to view the current solved 
word.

Events are emitted to update the users of the state of the game. They may
be useful for building a front end that uses this contract.

## Hardhat
This project was built on HardHat out of the "basic project template".

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
