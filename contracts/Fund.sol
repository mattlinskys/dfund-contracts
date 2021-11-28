// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Fund is ERC20 {
  constructor(uint256 initialSupply) ERC20("Fund", "FUND") {
    _mint(msg.sender, initialSupply);
  }
}