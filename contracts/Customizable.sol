// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Customizable {
    mapping(string => string) public customKeys;

    function setCustomKey(string memory key, string memory value) public {
        customKeys[key] = value;
    }
}
