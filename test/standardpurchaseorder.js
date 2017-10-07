let StandardPurchaseOrder = artifacts.require("./StandardPurchaseOrder.sol");

contract('StandardPurchaseOrder', (accounts) => {
  it("should initialize the order", () => {
    let po;
    let extraData = [
      "0x1234000000000000000000000000000000000000000000000000000000000000",
      "0x5678000000000000000000000000000000000000000000000000000000000000"
    ];
    return StandardPurchaseOrder.deployed().then((instance) => {
      po = instance;
      return po.initializeOrder(extraData, {from: accounts[0]});
    }).then(() => {
      return po.getOrder.call();
    }).then((order) => {
      assert.deepEqual(order, extraData, "order was not initialized");
    });
  });

  it("should be able to accept the order", () => {
    let po;
    return StandardPurchaseOrder.deployed().then((instance) => {
      po = instance;
      return po.setSupplier(accounts[1], {from: accounts[0]});
    }).then(() => {
      return po.accept({from: accounts[1]});
    }).then(() => {
      return po.status.call();
    }).then((status) => {
      assert.equal(status, "ACCEPTED", "order was not accepted");
    });
  });

  it("should be able to fulfill the order", () => {
    let po;
    return StandardPurchaseOrder.deployed().then((instance) => {
      po = instance;
      return po.fulfill({from: accounts[1]});
    }).then(() => {
      return po.status.call();
    }).then((status) => {
      assert.equal(status, "FULFILLED", "order was not fulfilled");
    });
  });

  it("should be able to receive the order", () => {
    let po;
    return StandardPurchaseOrder.deployed().then((instance) => {
      po = instance;
      return po.receive({from: accounts[0]});
    }).then(() => {
      return po.status.call();
    }).then((status) => {
      assert.equal(status, "RECEIVED", "order was not fulfilled");
    });
  });
});