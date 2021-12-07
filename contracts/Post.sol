// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./Customizable.sol";
import "./Factorable.sol";

contract Post is Ownable, Customizable {
    using Counters for Counters.Counter;

    struct Fundraising {
        uint256 goal;
        uint256 deadline;
    }

    struct Comment {
        uint256 id;
        uint256 time;
        string content;
        uint256 parent;
        uint256[] replies;
    }

    uint256 public time;
    string public content;
    Fundraising public fundraising;

    Counters.Counter public idCounter;
    mapping(uint256 => Comment) public comments;

    constructor(string memory _content) {
        time = block.timestamp;
        content = _content;
    }

    function addComment(string memory _content, uint256 _parent) public {
        require(
            _parent == 0 || comments[_parent].id > 0,
            "Parent doesn't exist"
        );

        idCounter.increment();

        uint256 id = idCounter.current();

        Comment memory comment;
        comment.id = id;
        comment.time = block.timestamp;
        comment.content = _content;
        comment.parent = _parent;

        if (_parent >= 0) {
            comments[_parent].replies.push(id);
        }

        comments[id] = comment;
        // TODO: Event
    }
}
