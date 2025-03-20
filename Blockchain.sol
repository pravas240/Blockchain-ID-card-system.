// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainIDCard {

    struct IDCard {
        uint256 id;
        string fullName;
        uint256 dateOfBirth;
        string nationality;
        string gender;
        string addressDetails;
        bool isActive;
    }

    mapping(uint256 => IDCard) public idCards;
    mapping(address => uint256[]) public userCards;

    uint256 public nextId = 1;

    event IDCardCreated(uint256 indexed id, address indexed owner);
    event IDCardUpdated(uint256 indexed id, address indexed owner);
    event IDCardDeactivated(uint256 indexed id, address indexed owner);

    modifier onlyCardOwner(uint256 id) {
        require(userCards[msg.sender].length > 0, "No cards associated with this address.");
        bool isOwner = false;
        for (uint i = 0; i < userCards[msg.sender].length; i++) {
            if (userCards[msg.sender][i] == id) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "You are not the owner of this ID card.");
        _;
    }

    function createIDCard(string memory _fullName, uint256 _dateOfBirth, string memory _nationality, string memory _gender, string memory _addressDetails) public {
        uint256 newId = nextId++;
        IDCard memory newCard = IDCard({
            id: newId,
            fullName: _fullName,
            dateOfBirth: _dateOfBirth,
            nationality: _nationality,
            gender: _gender,
            addressDetails: _addressDetails,
            isActive: true
        });
        
        idCards[newId] = newCard;
        userCards[msg.sender].push(newId);
        
        emit IDCardCreated(newId, msg.sender);
    }

    function updateIDCard(uint256 id, string memory _fullName, uint256 _dateOfBirth, string memory _nationality, string memory _gender, string memory _addressDetails) public onlyCardOwner(id) {
        IDCard storage card = idCards[id];
        
        card.fullName = _fullName;
        card.dateOfBirth = _dateOfBirth;
        card.nationality = _nationality;
        card.gender = _gender;
        card.addressDetails = _addressDetails;
        
        emit IDCardUpdated(id, msg.sender);
    }

    function deactivateIDCard(uint256 id) public onlyCardOwner(id) {
        IDCard storage card = idCards[id];
        card.isActive = false;
        
        emit IDCardDeactivated(id, msg.sender);
    }

    function getIDCardDetails(uint256 id) public view returns (IDCard memory) {
        return idCards[id];
    }

    function getUserCards() public view returns (uint256[] memory) {
        return userCards[msg.sender];
    }
}
