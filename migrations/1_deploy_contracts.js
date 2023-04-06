const TeamNft = artifacts.require("TeamNft");

module.exports = function(deployer) {
  deployer.deploy(TeamNft);
};
