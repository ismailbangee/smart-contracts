// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Rent {

    address public immutable owner;
    uint256 private counterProperty;
    uint256 private counterTenant;

    struct property {
        uint256 id;
        address renter;
        string title;
        string imgUrl;
        string completeAddress;
        string longitude;
        string latitude;
        uint256 rentPerMonth;
        string description;
        string status;
    }


    struct tenant { 
        uint256 id;
        address tenant;
        string name;
        string phone;
        string email;
    }
    
    mapping(uint256 => property) properties;

    mapping(uint256 => tenant) tenants;

    mapping(uint256 => uint256) tenantsProperty;

    constructor() {
        owner = msg.sender;
    }


    modifier isAlreadyRented(uint256 propertyId) {

        string memory currentStatus = properties[propertyId].status;

        require(
                keccak256(abi.encodePacked(currentStatus)) == keccak256(abi.encodePacked('available')),
                "Already Rented"
            );

        _;
    }

    function addProperty(
        string memory title,
        string memory imgUrl,
        string memory completeAddress,
        string memory longitude,
        string memory latitude,
        uint256 rentPerMonth,
        string memory description
        ) public {

        property storage newProperty = properties[counterProperty];    

        newProperty.renter = msg.sender;
        newProperty.id = counterProperty;
        newProperty.title = title;
        newProperty.imgUrl = imgUrl;
        newProperty.completeAddress = completeAddress;
        newProperty.longitude = longitude;
        newProperty.latitude = latitude;
        newProperty.rentPerMonth = rentPerMonth;
        newProperty.description = description;
        newProperty.status = 'available';

        counterProperty++;
    }

    function rentProperty(
        
        uint256 propertyId,
        string memory name,
        string memory phone,
        string memory email
        ) public isAlreadyRented(propertyId) {

        tenant storage newTenant = tenants[counterTenant];    

        newTenant.id = counterTenant;
        newTenant.tenant = msg.sender;
        newTenant.name = name;
        newTenant.phone = phone;
        newTenant.email = email;

        properties[propertyId].status = 'rented';

        tenantsProperty[counterTenant] = propertyId;
    }

    function propertyStatus(uint256 propertyId) public view returns (string memory) {
        return properties[propertyId].status;
    }
}