// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

import "./Customizable.sol";

contract Profile is Ownable, Customizable {
    bytes32 public name;

    constructor(address owner, bytes32 _name) {
        transferOwnership(owner);
        name = _name;
    }

    function setCustomKeys(bytes32[] memory keys, string[] memory values)
        public
        virtual
        override
        onlyOwner
    {
        super.setCustomKeys(keys, values);
    }

    function setCustomKey(bytes32 key, string memory value)
        public
        virtual
        override
        onlyOwner
    {
        super.setCustomKey(key, value);
    }
}
