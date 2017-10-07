/*
Abstract base purchase order.
Functions here are purely symbolic and are meant for record keeping more than asset tracking.
*/

pragma solidity ^0.4.8;

import "./BaseDB.sol";

contract PurchaseOrder {
    BaseDB.Asset[] order;
    string public status;

    /// @notice Marks the order as "ACCEPTED"
    /// @return Success of the operation
    function accept() returns (bool success);

    /// @notice Marks the order as "FULFILLED"
    /// @return Success of the operation
    function fulfill() returns (bool success);

    /// @notice Marks the order as "RECEIVED"
    /// @return Success of the operation
    function receive() returns (bool success);

    /// @notice Returns as bytes32[] because string[] is not a valid return type
    /// @return The extraData (requirements) for each asset in the order
    function getOrder() constant returns (bytes32[] _assetData);

    event StatusChange(string _status);
}