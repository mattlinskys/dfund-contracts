// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./Customizable.sol";
import "./Fundraising.sol";

struct Comment {
    uint256 time;
    string content;
    uint256 parentIndex;
    Comment[] replies;
}

contract Post {
    uint256 public time;
    string public content;
    Comment[] public comments;

    constructor(string memory _content) {
        content = _content;
    }
}

contract Project is AccessControlEnumerable, Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    event PostAdded(address indexed account);

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant DESIGNER_ROLE = keccak256("DESIGNER_ROLE");
    bytes32 public constant ACCOUNTANT_ROLE = keccak256("ACCOUNTANT_ROLE");

    address public factory;
    string public slug;
    EnumerableSet.AddressSet posts;

    constructor(address admin, string memory _slug) {
        factory = msg.sender;
        slug = _slug;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    modifier onlyFactory() {
        require(msg.sender == factory);
        _;
    }

    function getRoleMembers(bytes32 role)
        public
        view
        returns (address[] memory)
    {
        uint256 memberCount = getRoleMemberCount(role);
        address[] memory members = new address[](memberCount);
        uint256 i = 0;
        for (i = 0; i < memberCount; i++) {
            members[i] = getRoleMember(role, i);
        }

        return members;
    }

    function addPost(string calldata content)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        Post post = new Post(content);
        posts.add(address(post));

        emit PostAdded(address(post));
    }

    function destruct() public onlyFactory {
        selfdestruct(payable(msg.sender));
    }

    // TODO: removePost

    // function createFundraising(uint256 memory goal, uint256 memory deadline)
    //     public
    //     onlyRole(DEFAULT_ADMIN_ROLE)
    // {
    // }
}
