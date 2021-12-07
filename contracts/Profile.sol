// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./Customizable.sol";
import "./Factorable.sol";

contract Profile is Ownable, Factorable, Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 public name;
    EnumerableSet.AddressSet followedProjects;

    constructor(bytes32 _name) {
        name = _name;
    }

    modifier onlyOwnerOrFactory() {
        require(owner() == msg.sender || factory() == msg.sender);
        _;
    }

    function setCustomKeys(bytes32[] memory keys, string[] memory values)
        public
        virtual
        override
        onlyOwnerOrFactory
    {
        super.setCustomKeys(keys, values);
    }

    function setCustomKey(bytes32 key, string memory value)
        public
        virtual
        override
        onlyOwnerOrFactory
    {
        super.setCustomKey(key, value);
    }

    function addFollowedProject(address project) public onlyFactory {
        followedProjects.add(project);
    }

    function removeFollowedProject(address project) public onlyFactory {
        followedProjects.remove(project);
    }

    function getFollowedProject(address project) public view returns (bool) {
        return followedProjects.contains(project);
    }
}
