// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NftGatedEvent {
    address public eventNft;

    uint256 public eventCount;

    struct Event {
        uint256 id;
        string title;
        string description;
        string venue;
        address[] registeredUsers;
        string eventDate;
    }

    // mapping event id to Event struct. Using id to track events
    mapping(uint256 => Event) public events;

    // mapping of event ID to user address to bool
    // this checks if user has registered for a particular event ID
    mapping(uint256 => mapping(address => bool)) hasUserRegistered;

    Event[] eventsArray;

    constructor(address _eventNft) {
        eventNft = _eventNft;
    }

    function createEvent(
        string memory _title,
        string memory _description,
        string memory _venue,
        string memory _eventDate
    ) external {
        uint256 _newEventId = eventCount + 1;

        Event storage _event = events[_newEventId];
        _event.id = _newEventId;
        _event.title = _title;
        _event.description = _description;
        _event.venue = _venue;
        _event.eventDate = _eventDate;

        eventsArray.push(_event);

        eventCount = eventCount + 1;
    }

    function registerForEvent(uint256 _eventId) external {
        require(
            IERC721(eventNft).balanceOf(msg.sender) > 0,
            "not eligible for event"
        );
        require(!hasUserRegistered[_eventId][msg.sender], "already registered");

        Event storage _event = events[_eventId];
        _event.registeredUsers.push(msg.sender);

        hasUserRegistered[_eventId][msg.sender] = true;
    }

    function getAllEvents() external view returns (Event[] memory) {
        return eventsArray;
    }

    function viewEvent(uint256 _eventId) external view returns (Event memory) {
        return events[_eventId];
    }

    function checkRegistrationValidity(
        uint _eventId,
        address _userAddress
    ) external view returns (bool) {
        return hasUserRegistered[_eventId][_userAddress];
    }
}
