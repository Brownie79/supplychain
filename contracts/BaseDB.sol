/*
An abstract base DB for representing and transferring assets.
*/

pragma solidity ^0.4.8;

contract BaseDB {
    // Generic asset definition
    struct Asset {
        address owner;
        bytes32 extraData;
        bytes32[] inputs;
        bool spent;
    }

    /// @param _owner Address for which to get inventory
    /// @return The inventory in asset IDs
    function getInventory(address _owner) returns (bytes32[] assets);

    /// @param _assetId AssetID to get metadata for
    /// @return The asset object split into parts
    function getAsset(bytes32 _assetId) returns (address, bytes32, bytes32[]);

    /// @notice Creates a new asset in the DB
    /// @param _inputs The inputs required to create this asset
    /// @param _extraData Any extra string definition of the asset
    /// @return The asset ID of the asset created
    function createAsset(bytes32[] _inputs, bytes32 _extraData) returns (bytes32 assetId);

    /// @notice Transfers and asset to `_to` address
    /// @param _assetId The asset to transfer
    /// @param _to The address to send to
    /// @return Whether the transfer was successful or not
    function transfer(bytes32 _assetId, address _to) returns (bool success);

    event AssetCreation(bytes32 _assetId, address indexed _owner, bytes32 _extraData, bytes32[] _inputs);
    event Transfer(bytes32 indexed _assetId, address indexed _from, address indexed _to);
}