// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LotteryGame {
    address payable[] public players;
    address public gameManager;
    uint private minimumPlayers = 3;
    uint public balance;

    constructor() {
        gameManager = payable(msg.sender);
    }

    modifier minEther() {
        require(
            msg.value >= 0.1 ether,
            "Please send at least 0.1 Ether to participate in the game!"
        );
        _;
    }

    modifier minPlayers() {
        require(
            players.length >= minimumPlayers,
            "Minimum three players are required to participate!"
        );
        _;
    }

    modifier onlyManager() {
        require(
            msg.sender == gameManager,
            "Only the manager can pick the winner!"
        );
        _;
    }

    function enterInLottery() public payable minEther {
        players.push(payable(msg.sender));
        balance += msg.value;
    }

    function randomNumGenerator() public view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            ) % players.length;
    }

    function pickWinner() public onlyManager minPlayers returns (address) {
        uint winnerIndex = randomNumGenerator();
        address payable winner = players[winnerIndex];
        winner.transfer(balance);
        balance = 0;
        players = new address payable[](0);
        return winner;
    }
}
