var StandardAssetDB = artifacts.require("./StandardAssetDB.sol");
var StandardPurchaseOrder = artifacts.require("./StandardPurchaseOrder.sol");

module.exports = function(deployer) {
  deployer.deploy(StandardAssetDB);
  deployer.deploy(StandardPurchaseOrder);
};
