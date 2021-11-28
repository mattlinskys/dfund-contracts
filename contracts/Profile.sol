// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Customizable.sol";

contract Profile is Ownable, Customizable {
    string public name;
    string public avatarUri;

    constructor(address admin, string memory _name) {
        transferOwnership(admin);
        name = _name;
    }

    function setName(string calldata _name) public onlyOwner {
        name = _name;
    }

    function setAvatarUri(string calldata _avatarUri) public onlyOwner {
        avatarUri = _avatarUri;
    }
}
