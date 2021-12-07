// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Contract module that allows children to be controlled
 * by factory
 */
abstract contract Factorable {
    address private _factory;

    /**
     * @dev Initializes the contract setting the deployer as the factory
     */
    constructor() {
        _factory = msg.sender;
    }

    /**
     * @dev Returns the address of the factory
     */
    function factory() public view virtual returns (address) {
        return _factory;
    }

    /**
     * @dev Throws if called by any account other than the factory
     */
    modifier onlyFactory() {
        require(factory() == msg.sender, "Caller is not the factory");
        _;
    }
}
