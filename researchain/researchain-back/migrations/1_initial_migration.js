const Migrations = artifacts.require("Migrations");
const Papers = artifacts.require("Papers");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Papers);
};
