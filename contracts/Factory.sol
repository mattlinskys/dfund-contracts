// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

import "./Profile.sol";
import "./Project.sol";
import "./Fund.sol";

contract Factory is Ownable {
    event ProfileCreated(
        address indexed account,
        address indexed creator,
        bytes32 name
    );

    event ProjectCreated(
        address indexed account,
        address indexed creator,
        bytes32 slug,
        bytes32 name
    );

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    mapping(address => Profile) public profiles;
    mapping(bytes32 => Project) public projects;
    address public immutable fund;

    constructor() {
        fund = address(new Fund(100000));
    }

    function createProfile(
        bytes32 name,
        bytes32[] memory keys,
        string[] memory values
    ) external {
        require(
            address(profiles[msg.sender]) == address(0),
            "Profile is already created"
        );
        require(name != 0, "Empty name");

        Profile profile = new Profile(name);
        profile.setCustomKeys(keys, values);
        profile.transferOwnership(msg.sender);
        profiles[msg.sender] = profile;

        emit ProfileCreated(address(profile), msg.sender, name);
    }

    function createProject(
        bytes32 slug,
        bytes32 name,
        bytes32[] memory keys,
        string[] memory values
    ) external {
        require(
            address(projects[slug]) == address(0),
            "Project slug is already taken"
        );

        Project project = new Project(msg.sender, slug, name);
        project.setCustomKeys(keys, values);
        projects[slug] = project;

        emit ProjectCreated(address(project), msg.sender, slug, name);
    }

    function deleteProject(bytes32 slug) external {
        // TODO:
        // require(
        //     projects[slug].hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
        //     "You must be an admin to delete project"
        // );

        delete projects[slug];
        projects[slug].destruct();
    }

    function followProject(bytes32 slug) external {
        require(Profile(profiles[msg.sender]).name() != 0);
        require(Project(projects[slug]).slug() != 0);

        Profile(profiles[msg.sender]).addFollowedProject(
            address(projects[slug])
        );
        Project(projects[slug]).addFollower(msg.sender);
    }

    function unfollowProject(bytes32 slug) external {
        require(Profile(profiles[msg.sender]).name() != 0);
        require(Project(projects[slug]).slug() != 0);

        Profile(profiles[msg.sender]).removeFollowedProject(
            address(projects[slug])
        );
        Project(projects[slug]).removeFollower(msg.sender);
    }
}
