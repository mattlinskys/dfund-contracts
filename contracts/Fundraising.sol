// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Customizable.sol";

contract Fundraising is Customizable {
    address public project;
    uint256 public goal;
    uint256 public deadline;

    constructor(
        address _project,
        uint256 _goal,
        uint256 _deadline
    ) {
        require(_goal > 0, "Goal must be bigger than 0");
        require(
            _deadline > block.timestamp,
            "Deadline must be greated than current timestamp"
        );

        project = _project;
        goal = _goal;
        deadline = _deadline;
    }
}
