// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Post.sol";

contract Fundraising is Post {
    uint256 public goal;
    uint256 public deadline;

    constructor(
        uint256 _goal,
        uint256 _deadline,
        string memory _content
    ) Post(_content) {
        require(_goal > 0, "Invalid goal");
        require(_deadline > block.timestamp, "Invalid deadline");

        goal = _goal;
        deadline = _deadline;
    }
}
