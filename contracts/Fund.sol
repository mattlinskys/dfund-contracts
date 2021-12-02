// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Fund is ERC20, Ownable {
    uint256 public swappableSupply;
    uint256 public swapRate;

    constructor(uint256 initialSupply) ERC20("Fund", "FUND") {
        _mint(msg.sender, initialSupply);
    }

    function swapEth() public payable {
        require(msg.value > 0, "No ETH");
        require(swapRate > 0, "Swapping disabled");
        require(swappableSupply >= msg.value * swapRate, "ETH exhausted");

        uint256 amount = msg.value * swapRate;
        swappableSupply -= amount;

        // payable(0x000000000000000000000000000000000000dEaD).transfer(msg.value);
        transfer(msg.sender, amount);
    }

    function mintSwappableSupply(uint256 _supply) public onlyOwner {
        swappableSupply += _supply;
    }

    function setSwapRate(uint256 _rate) public onlyOwner {
        swapRate = _rate;
    }
}
