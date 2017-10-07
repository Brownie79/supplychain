pragma solidity ^0.4.8;

import "./BaseDB.sol";
import "./PurchaseOrder.sol";

contract StandardPurchaseOrder is PurchaseOrder {
    BaseDB.Asset[] order;
    address requester;
    address supplier;
    
    modifier onlysupplier {
        // Only the supplier can call
        if (msg.sender == supplier)
        _;
    }
    
    modifier onlyrequester {
        // Only the requester can call
        if (msg.sender == requester)
        _;
    }
    
    modifier onlystatus(bytes1 _char) {
        // Only callable is status is `_char`
        if (bytes(status)[0] == _char)
        _;
    }
    
    function StandardPurchaseOrder() {
        requester = msg.sender; // Requester is contract creator
        status = "CREATED";
    }

    function setSupplier(address _supplier) onlyrequester returns (bool success) {
        supplier = _supplier;
        return true;
    }
    
    function initializeOrder(bytes32[] _assetData) onlystatus("C") returns (bool success) {
        BaseDB.Asset memory asset;
        for (uint i = 0; i < _assetData.length; i++) {
            asset.extraData = _assetData[i];
            order.push(asset);
        }
        setStatus("PENDING");
        return true;
    }

    function getOrder() constant returns (bytes32[] _assetData) {
        _assetData = new bytes32[](order.length); // Can't use Array.push for memory arrays
        for (uint i = 0; i < order.length; i++) {
            _assetData[i] = order[i].extraData;
        }
        return _assetData;
    }
    
    function accept() onlysupplier onlystatus("P") returns (bool success) {
        setStatus("ACCEPTED");
        return true;
    }
    
    function fulfill() onlysupplier onlystatus("A") returns (bool success) {
        setStatus("FULFILLED");
        return true;
    }
    
    function receive() onlyrequester onlystatus("F") returns (bool success) {
        setStatus("RECEIVED");
        return true;
    }

    function setStatus(string _status) internal {
        status = _status;
        StatusChange(status);
    }
    
    event StatusChange(string _status);
}