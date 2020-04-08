const addservice = artifacts.require("../contracts/AddService.sol");
const badAdd = artifacts.require("../contracts/BadAdder.sol");
module.exports = function(deployer) {
  deployer.deploy(addservice);
  deployer.deploy(badAdd);
};
