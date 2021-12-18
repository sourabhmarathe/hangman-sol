//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Hangman {
    string private secret;
    string public guesses;
    string public solution;
    uint16 public lives;

    constructor(string memory _secret, uint16 _lives) {
        secret = _secret;
        guesses = "";
        lives = _lives;
        for (uint i = 0; i < bytes(secret).length; i++) {
            abi.encodePacked(solution, "_");
        }
    }

    event Outcome(string message);
    event CorrectGuess(string guessesMade, string solution);
    event IncorrectGuess(uint livesRemaining);

    // Helper function that returns true if {what} is a substring of {where}
    function contains(string memory what, string memory where) pure internal returns (bool) {
        bytes memory whatBytes = bytes(what);
        bytes memory whereBytes = bytes(where);

        for (uint i = 0; i < whereBytes.length - whatBytes.length; i++) {
            for (uint j = 0; j < whatBytes.length; j++) {
                if (whereBytes [i + j] == whatBytes [j]) {
                    return true;
                }
            }
        }
        return false;
    }

    function secretSolved() internal view returns (bool) {
        bytes memory solutionBytes = bytes(solution);
        bytes memory secretBytes = bytes(secret);
        for (uint i = 0; i < secretBytes.length; i++) {
            if (solutionBytes[i] != secretBytes[i]) {
                return false;
            }
        }
        return true;
    }

    function makeGuess(string memory _guess) external {
        require(bytes(_guess).length == 1);
        require(!contains(_guess, guesses));

        // Append to the current set of guesses
        string(abi.encodePacked(guesses, _guess));

        // Check if the guess is correct
        if (!contains(secret, _guess)) {
            lives = lives - 1;
            if (lives == 0) {
                emit Outcome("Guesser has lost");
                return;
            }
            emit IncorrectGuess(lives);
            return;
        }

        // Update the solution
        bytes memory solutionBytes = bytes(solution);
        bytes memory secretBytes = bytes(secret);
        bytes memory guessByte = bytes(_guess);
        for (uint256 i = 0; i < solutionBytes.length; i++) {
            if (guessByte[0] == secretBytes[i]) {
                solutionBytes[i] = guessByte[0];
            }
        }
        solution = string(solutionBytes);

        if (secretSolved()) {
            emit Outcome("Guesser has won");
            return;
        }

        emit CorrectGuess(guesses, solution);
    }
}