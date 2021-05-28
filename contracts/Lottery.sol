pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    modifier restricted() {
        require(manager == msg.sender);
        _;
    }

    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }

    function getPlayers() public view returns (address[]) {
        return players;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether);
        players.push(msg.sender);
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance);

        //reset the players
        players = new address[](0);
    }

    function getBalance() public view restricted returns (uint) {
        return this.balance;
    }

}
