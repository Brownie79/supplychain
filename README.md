# supply-chain

The Axiom SupplyChain project is designed model a supply chain on Ethereum. The basic flow allows for anyone to create assets. The owner of the contract can add and remove certifiers in the system. Certifiers can certify and revoke certifications for users. Owners of assets can transfer assets to other users.

## Setup

This project uses the [truffle framework](http://truffleframework.com/) to handle builds and unit tests, which requires [Node.js 5.0+](https://nodejs.org/en/). It is also recommended to use [TestRPC](https://github.com/ethereumjs/testrpc) as your Ethereum client while running tests. This simulates full client behavior but does NOT connect to Ethereum networks. This project also uses packages via `npm`, so you'll need to `npm install`. 

The basic setup for this project is as follows:

```
$ npm install -g truffle ethereumjs-testrpc
$ git clone git@gitlab.com:axiomblockchain/ethereum/supply-chain.git
$ cd supply-chain
$ npm install
```

## TestRPC

`TestRPC` is basically an "in-memory" blockchain - it simulates Ethereum behavior without being connected to any other clients. It's recommended to use it while running tests. Once you've followed the steps in `Setup`, run TestRPC via:

```
$ testrpc
```

You don't need to worry about any additional options for now.

## Running tests

The easiest way to run tests is simply via

```
$ truffle test
```

This will compile, build, deploy, and test contracts. The results of the test will be displayed in your terminal.

## Contracts

This section contains a basic description of the contracts located in `contracts/`.

`BaseDB.sol` (Abstract): Defines a generic DB that contains `Assets`.

`AssetDB.sol` (Abstract): Extends `BaseDB`, adds concept of `Actors` and `Certifiers`. 

`StandardAssetDB.sol`: Implements `AssetDB`.

`PurchaseOrder.sol` (Abstract): Defines a generic purchase order.

`StandardPurchaseOrder.sol`: Implements `PurchaseOrder`.

## Test Coverage

[✔] `StandardAssetDB.sol`

[✔] `StandardPurchaseOrder.sol`