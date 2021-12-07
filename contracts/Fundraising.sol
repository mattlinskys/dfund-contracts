// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Post.sol";
import "./Project.sol";
import "./Factory.sol";
import "./Fund.sol";

contract Fundraising is Post {
    uint256 public goal;
    uint256 public deadline;

    constructor(
        string memory _content,
        uint256 _goal,
        uint256 _deadline
    ) Post(_content) {
        require(_goal > 0, "Invalid goal");
        require(_deadline > block.timestamp, "Invalid deadline");

        goal = _goal;
        deadline = _deadline;
    }

    modifier isActive() {
        require(
            goal >
                Fund(Factory(Project(owner()).factory()).fund()).balanceOf(
                    address(this)
                )
        );
        require(deadline < block.timestamp);
        _;
    }

    modifier hasEnded() {
        require(
            goal <=
                Fund(Factory(Project(owner()).factory()).fund()).balanceOf(
                    address(this)
                ) ||
                deadline >= block.timestamp
        );
        _;
    }

    function donate() public isActive {
        Fund fund = Fund(Factory(Project(owner()).factory()).fund());

        uint256 allowance = fund.allowance(msg.sender, address(this));
        require(allowance > 0, "Inefficient allowance");

        fund.transferFrom(msg.sender, address(this), allowance);
    }

    function release() public onlyOwner hasEnded {
        Project project = Project(owner());
        Fund fund = Fund(Factory(project.factory()).fund());

        fund.transfer(address(project), fund.balanceOf(address(this)));
    }
}
