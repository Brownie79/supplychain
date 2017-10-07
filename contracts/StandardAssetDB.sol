/* 
This contract represents a database of all available assets for all vendors in the supply chain. 
*/

pragma solidity ^0.4.8;

import "./AssetDB.sol";

contract StandardAssetDB is AssetDB {
    mapping (address => Certifier) certifiers;
    mapping (address => Actor) actors;
    mapping (bytes32 => Asset) assets;
    mapping (address => bytes32[]) inventory;

    uint256 public totalAssets = 0;

    address owner;
    
    function () {
        // Don't allow ether to be sent to this contract
        revert();
    }

    function StandardAssetDB() {
        owner = msg.sender; // Set the owner of this contract
    }

    modifier onlyowner {
        // Only the owner of this contract can call
        if (msg.sender == owner)
        _;
    }
    
    modifier onlyowns(bytes32 _assetId) {
        // Only the owner of this asset can call
        if (owns(_assetId, msg.sender))
        _;
    }
    
    modifier onlyownsall(bytes32[] _assetIds) {
        // Only the owner of all inputs can call
        if (ownsAll(_assetIds, msg.sender))
        _;
    }

    modifier onlynonespent(bytes32[] _assetIds) {
        // Only can spend if no assets are spent
        if (noneSpent(_assetIds))
        _;
    }
    
    modifier onlycertifier {
        // Only certifiers can call
        if (certifiers[msg.sender].active == true)
        _;
    }
    
    function owns(bytes32 _assetId, address _owner) internal returns (bool) {
        return assets[_assetId].owner == _owner;
    }
    
    function ownsAll(bytes32[] _assetIds, address _owner) internal returns (bool) {
        bool ownsAll = true;
        for (uint i = 0; i < _assetIds.length; i++) {
            if (!owns(_assetIds[i], _owner)) {
                ownsAll = false;
            }
        }
        return ownsAll;
    }

    function spent(bytes32 _assetId) internal returns (bool) {
        return assets[_assetId].spent;
    }

    function noneSpent(bytes32[] _assetIds) internal returns (bool) {
        bool noneSpent = true;
        for (uint i = 0; i < _assetIds.length; i++) {
            if (spent(_assetIds[i])) {
                noneSpent = false;
            }
        }
        return noneSpent;
    }

    function getInventory(address _owner) returns (bytes32[] assets) {
        return inventory[_owner];
    }

    function getAsset(bytes32 _assetId) returns (address, bytes32, bytes32[]) {
        Asset memory asset = assets[_assetId];
        return (asset.owner, asset.extraData, asset.inputs); // Structs can't be return types, need to be returned like this
    }

    function createAsset(bytes32[] _inputs, bytes32 _extraData) onlyownsall(_inputs) onlynonespent(_inputs) returns (bytes32 assetId) {
        assetId = bytes32(totalAssets); // Just one way to give assets unique IDs

        assets[assetId].owner = msg.sender;
        assets[assetId].extraData = _extraData;
        assets[assetId].inputs = _inputs;

        for (uint i = 0; i < _inputs.length; i++) {
            assets[_inputs[i]].spent = true;
        }

        inventory[msg.sender].push(assetId);
        totalAssets++;
        
        AssetCreation(assetId, msg.sender, _extraData, _inputs);
        return assetId;
    }
    
    function transfer(bytes32 _assetId, address _to) onlyowns(_assetId) returns (bool success) {
        assets[_assetId].owner = _to;
        inventory[_to].push(_assetId);
        Transfer(_assetId, msg.sender, _to);
        return true;
    }

    function getActor(address _actor) returns (bool, address) {
        Actor memory actor = actors[_actor];
        return (actor.certified, actor.certifier);
    }
    
    function getCertifier(address _certifier) returns (string, bool) {
        Certifier memory certifier = certifiers[_certifier];
        return (certifier.name, certifier.active);
    }

    function certify(address _actor) onlycertifier returns (bool success) {
        actors[_actor].certified = true;
        actors[_actor].certifier = msg.sender;
        Certification(msg.sender, _actor);
        return true;
    }
    
    function revoke(address _actor) onlycertifier returns (bool success) {
        actors[_actor].certified = false;
        actors[_actor].certifier = 0x0000000000000000000000000000000000000000; // Consider 0x0 as uncertified
        Revocation(msg.sender, _actor);
        return true;
    }

    function addCertifier(address _certifier, string _name) onlyowner returns (bool success) {
        certifiers[_certifier].active = true;
        certifiers[_certifier].name = _name;
        return true;
    }

    function removeCertifier(address _certifier) onlyowner returns (bool success) {
        certifiers[_certifier].active = false;
        return true;
    }
}