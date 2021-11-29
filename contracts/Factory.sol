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
        string name
    );

    event ProjectCreated(
        address indexed account,
        address indexed creator,
        string slug
    );

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    mapping(address => Profile) public profiles;
    mapping(string => Project) public projects;
    Fund public fund;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        fund = new Fund(100000);
    }

    function createProfile(string calldata name) public {
        require(
            address(profiles[msg.sender]) == address(0),
            "Profile is already created"
        );

        // TODO: Validate length
        Profile profile = new Profile(msg.sender, name);
        profiles[msg.sender] = profile;

        emit ProfileCreated(address(profile), msg.sender, name);
    }

    function createProject(string calldata slug, string calldata name) public {
        // TODO: Slug validation (library)
        require(
            address(projects[slug]) == address(0),
            "Project slug is already taken"
        );

        Project project = new Project(msg.sender, slug, name);
        projects[slug] = project;

        emit ProfileCreated(address(project), msg.sender, slug);
    }

    function deleteProject(string calldata slug) public {
        require(
            projects[slug].hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "You must be an admin to delete project"
        );

        delete projects[slug];
        projects[slug].destruct();
    }
}
