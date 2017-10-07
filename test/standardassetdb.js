let leftPad = require("left-pad");
let StandardAssetDB = artifacts.require("./StandardAssetDB.sol");

contract('StandardAssetDB', (accounts) => {
  it("should create assets correctly", () => {
    let db;
    let extraData = "0x1234000000000000000000000000000000000000000000000000000000000000";
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.createAsset([], extraData, {from: accounts[0]});
    }).then(() => {
      return db.totalAssets.call();
    }).then((totalAssets) => {
      let assetId = "0x" + leftPad(totalAssets-1, 64, 0);
      return db.getAsset.call(assetId);
    }).then((asset) => {
      assert.equal(asset[1], extraData, "asset was not created correctly");
    });
  });

  it("should get the inventory for a user", () => {
    let db;
    let extraData = "0x5678000000000000000000000000000000000000000000000000000000000000";
    let assetId;
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.createAsset([], extraData, {from: accounts[1]});
    }).then(() => {
      return db.totalAssets.call();
    }).then((totalAssets) => {
      assetId = "0x" + leftPad(totalAssets-1, 64, 0);
      return db.getInventory.call(accounts[1]);
    }).then((inventory) => {
      assert.deepEqual(inventory, [assetId], "inventory was not returned correctly");
    });
  });

  it("should allow transfers", () => {
    let db;
    let extraData = "0x9101112000000000000000000000000000000000000000000000000000000000";
    let assetId;
    let inventory;
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.createAsset([], extraData, {from: accounts[2]});
    }).then(() => {
      return db.totalAssets.call();
    }).then((totalAssets) => {
      assetId = "0x" + leftPad(totalAssets-1, 64, 0);
      return db.transfer(assetId, accounts[3], {from: accounts[2]});
    }).then(() => {
      return db.getInventory.call(accounts[3]);
    }).then((_inventory) => {
      inventory = _inventory;
      return db.getAsset.call(assetId);
    }).then((asset) => {
      assert.equal(asset[0], accounts[3], "owner was not changed");
      assert.deepEqual(inventory, [assetId], "owner inventory was not updated");
    });
  });

  it("should allow certiers to be added by the owner", () => {
    let db;
    let certifierName = "CERTIFIER_1";
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.addCertifier(accounts[1], certifierName, {from: accounts[0]});
    }).then(() => {
      return db.getCertifier.call(accounts[1]);
    }).then((certifier) => {
      assert.deepEqual(certifier, [certifierName, true], "certifier was not added");
    });
  });

  it("should allow certiers to be removed by the owner", () => {
    let db;
    let certifierName = "CERTIFIER_2";
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.addCertifier(accounts[2], certifierName, {from: accounts[0]});
    }).then(() => {
      return db.removeCertifier(accounts[2]);
    }).then(() => {
      return db.getCertifier.call(accounts[2]);
    }).then((certifier) => {
      assert.deepEqual(certifier, [certifierName, false], "certifier was not removed");
    });
  });

  it("should allow certiers to certify an actor", () => {
    let db;
    let certifierName = "CERTIFIER_3";
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.addCertifier(accounts[3], certifierName, {from: accounts[0]});
    }).then(() => {
      return db.certify(accounts[4], {from: accounts[3]});
    }).then(() => {
      return db.getActor.call(accounts[4]);
    }).then((actor) => {
      assert.deepEqual(actor, [true, accounts[3]], "actor was not certified");
    });
  });

  it("should allow certiers to revoke the cert for an actor", () => {
    let db;
    let certifierName = "CERTIFIER_4";
    return StandardAssetDB.deployed().then((instance) => {
      db = instance;
      return db.addCertifier(accounts[4], certifierName, {from: accounts[0]});
    }).then(() => {
      return db.certify(accounts[5], {from: accounts[4]});
    }).then(() => {
      return db.revoke(accounts[5], {from: accounts[4]})
    }).then(() => {
      return db.getActor.call(accounts[5]);
    }).then((actor) => {
      assert.deepEqual(actor, [false, "0x0000000000000000000000000000000000000000"], "cert was not revoked");
    });
  });
});