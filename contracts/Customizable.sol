// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Customizable {
    mapping(bytes32 => string) public customKeys;

    function setCustomKeys(bytes32[] memory keys, string[] memory values)
        public
        virtual
    {
        for (uint256 i = 0; i < keys.length; i++) {
            customKeys[keys[i]] = values[i];
        }
    }

    function setCustomKey(bytes32 key, string memory value) public virtual {
        customKeys[key] = value;
    }
}
