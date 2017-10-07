/*
An abstract extension of the BaseDB contract to handle certifications
*/

pragma solidity ^0.4.8;

import "./BaseDB.sol";

contract AssetDB is BaseDB {
    // Generic certifier definition
    struct Certifier {
        bool active;
        string name;
    }
    
    // Generic actor (user of system) definition
    struct Actor {
        bool certified;
        address certifier; 
    }

    /// @param _actor Address of actor to get
    /// @return Data for the actor
    function getActor(address _actor) returns (bool, address);

    /// @param _certifier Address of certifier to get
    /// @return Data for the certifier 
    function getCertifier(address _certifier) returns (string, bool);

    /// @notice Marks an actor as certified
    /// @param _actor Address of actor to mark as certified
    /// @return Success of the operation
    function certify(address _actor) returns (bool success);

    /// @notice Revokes an actor's certification
    /// @param _actor Address of actor whose certification to revoke
    /// @return Success of the operation
    function revoke(address _actor) returns (bool success);

    /// @notice Adds a certifier
    /// @param _certifier Address of certifier to add
    /// @param _name Name of new certifier
    /// @return Success of the operation
    function addCertifier(address _certifier, string _name) returns (bool success);

    /// @notice Removes a certifier
    /// @param _certifier Address of certifier to remove
    /// @return Success of the operation
    function removeCertifier(address _certifier) returns (bool success);

    event Certification(address indexed _certifier, address indexed _actor);
    event Revocation(address indexed _certifier, address indexed _actor);
}