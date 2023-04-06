// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TeamNft is ERC721, Ownable {

	uint256 public price = 0.01 ether;
	uint256 public maxSupply = 2;
	bool public mintEnabled = true;

	struct Avatar {
		string name;
  	}

  	Avatar[] public avatars;

	mapping (uint => address) public avatarToOwner;
	mapping (address => uint) ownerAvatarCount;

	constructor() payable ERC721("Avatar", "AVT") {
		avatars.push(Avatar("Antoine - Perso"));
		avatars.push(Avatar("Antoine - Equipe"));
		avatars.push(Avatar("Julien - Perso"));
		avatars.push(Avatar("Julien - Equipe"));
		avatars.push(Avatar("Heddi - Perso"));
		avatars.push(Avatar("Heddi - Equipe"));
		avatars.push(Avatar("Yanny - Perso"));
		avatars.push(Avatar("Yanny - Equipe"));
		avatars.push(Avatar("Thomas - Perso"));
		avatars.push(Avatar("Thomas - Equipe"));
		avatars.push(Avatar("Youssef - Perso"));
		avatars.push(Avatar("Youssef - Equipe"));
		avatars.push(Avatar("Baptiste - Perso"));
		avatars.push(Avatar("Baptiste - Equipe"));
		avatars.push(Avatar("Mael - Perso"));
		avatars.push(Avatar("Mael - Equipe"));
	}

	/*
	* Owner functions
	*/
	function toggleMintEnabled() external onlyOwner {
		mintEnabled  = !mintEnabled;
	}

	function setMaxSupply(uint _maxSupply) external onlyOwner {
		maxSupply = _maxSupply;
	}

	/*
	* Users functions
	*/
	function ownerOf(uint256 _tokenId) public override view returns (address _owner) {
		return avatarToOwner[_tokenId];
	}

	function mint(uint256 _tokenId) external payable {
		require(mintEnabled, "L'achat est suspendu.");
		require(ownerAvatarCount[msg.sender] < maxSupply, "Vous avez le maximum d'avatars.");
		require(msg.value == price, "Le prix n'est pas le bon.");
		require(avatarToOwner[_tokenId] == address(0x0), "Cet avatar est possede par quelqu'un.");

		ownerAvatarCount[msg.sender]++;
		_safeMint(msg.sender, _tokenId);
	}
}