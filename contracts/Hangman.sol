//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Hangman {
    string private secret;
    string public guesses;
    string public solution;
    uint16 public lives;

    constructor(string memory _secret, uint16 _lives) {
        secret = _secret;
        guesses = "";
        lives = _lives;
        bytes memory solutionBytes = bytes(secret);
        for (uint i = 0; i < bytes(secret).length; i++) {
            solutionBytes[i] = "_";
        }
        solution = string(solutionBytes);
    }

    event Outcome(string message);
    event CorrectGuess(string guessesMade, string solution);
    event IncorrectGuess(uint livesRemaining);

    // Helper function that returns true if {where} is a substring of {what}
    function contains(string memory what, string memory where) pure internal returns (bool) {
        if (bytes(where).length == 0 || bytes(what).length == 0) {
            return false;
        }
        bytes memory whatBytes = bytes (what);
        bytes memory whereBytes = bytes (where);

        for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            for (uint j = 0; j < whatBytes.length; j++)
                if (whereBytes [i + j] != whatBytes [j]) {
                    flag = false;
                    break;
                }
            if (flag) {
                return true;
            }
        }
        return false;
    }

    function secretSolved() internal view returns (bool) {
        bytes memory solutionBytes = bytes(solution);
        bytes memory secretBytes = bytes(secret);
        for(uint i = 0; i < secretBytes.length; i++) {
            if(solutionBytes[i] != secretBytes[i]) {
                return false;
            }
        }
        return true;
    }

    function makeGuess(string memory _guess) external {
        require(bytes(_guess).length == 1, "you may only guess one character");
        require(!contains(_guess, guesses), "you already guessed that");
        require(lives > 0, "must have at least one life to make a guess");

        // Append to the current set of guesses
        guesses = string(abi.encodePacked(guesses, _guess));

        // Check if the guess is correct
        if(!contains(_guess, secret)) {
            lives = lives - 1;
            if(lives == 0) {
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
        for(uint256 i = 0; i < solutionBytes.length; i++) {
            if(guessByte[0] == secretBytes[i]) {
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