// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./Customizable.sol";
import "./Fundraising.sol";
import "./Post.sol";

contract Project is AccessControlEnumerable, Ownable, Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    event PostAdded(address indexed account);
    event PostRemoved(address indexed account);

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant DESIGNER_ROLE = keccak256("DESIGNER_ROLE");
    bytes32 public constant ACCOUNTANT_ROLE = keccak256("ACCOUNTANT_ROLE");

    bytes32 public slug;
    bytes32 public name;
    EnumerableSet.AddressSet posts;
    EnumerableSet.AddressSet pinnedPosts;

    constructor(
        address admin,
        bytes32 _slug,
        bytes32 _name
    ) {
        slug = _slug;
        name = _name;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
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

    function removePost(address post) public onlyRole(DEFAULT_ADMIN_ROLE) {
        bool removed = posts.remove(post);
        pinnedPosts.remove(post);

        if (removed) {
            emit PostRemoved(post);
        }
    }

    function postCount() external view returns (uint256) {
        return posts.length();
    }

    function getPaginatiedPosts(uint256 _page, uint256 _pageSize)
        external
        view
        returns (address[] memory)
    {
        uint256 index = _page * _pageSize - _pageSize;

        if (posts.length() == 0 || index > posts.length() - 1) {
            return new address[](0);
        }

        return new address[](0);
    }

    function destruct() public onlyOwner {
        // selfdestruct(payable(msg.sender));
    }

    // TODO: removePost

    // function createFundraising(uint256 memory goal, uint256 memory deadline)
    //     public
    //     onlyRole(DEFAULT_ADMIN_ROLE)
    // {
    // }
}
