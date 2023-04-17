// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract LotteryGame {
    address payable[] public players;
    address gameManager;
    uint private minimumPlayers = 3;
    uint public balance;

    constructor() {
        gameManager = msg.sender;
    }

    modifier minEther() {
        require(
            msg.value >= 0.1 ether,
            "Please send 0.1 Ether to participate in the game!"
        );
        _;
    }

    modifier minPlayers() {
        require(
            players.length >= 3,
            "Minimun Three players are required to participate!"
        );
        _;
    }

    function enterInLottery() public payable minEther {
        players.push(payable(msg.sender));
        balance += msg.value;
    }

    function randomNumGenerater() public view returns (uint) {
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

    function pickWinner() public minPlayers returns (address) {
        uint winnerIndex = randomNumGenerater();
        address payable winner = players[winnerIndex];
        winner.transfer(balance);
        balance = 0;
        players = new address payable[](0);
        return winner;
    }
}
