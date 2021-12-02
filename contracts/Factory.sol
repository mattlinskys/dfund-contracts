// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

import "./Profile.sol";
import "./Project.sol";
import "./Fund.sol";

contract Factory is AccessControl {
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
    Fund public fund;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        fund = new Fund(100000);
    }

    function createProfile(bytes32 name) public {
        require(
            address(profiles[msg.sender]) == address(0),
            "Profile is already created"
        );
        require(name != 0, "Empty name");

        Profile profile = new Profile(msg.sender, name);
        profiles[msg.sender] = profile;

        emit ProfileCreated(address(profile), msg.sender, name);
    }

    function createProject(bytes32 slug, bytes32 name) public {
        require(
            address(projects[slug]) == address(0),
            "Project slug is already taken"
        );

        Project project = new Project(msg.sender, slug, name);
        projects[slug] = project;

        emit ProjectCreated(address(project), msg.sender, slug, name);
    }

    function deleteProject(bytes32 slug) public {
        require(
            projects[slug].hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "You must be an admin to delete project"
        );

        delete projects[slug];
        projects[slug].destruct();
    }
}
