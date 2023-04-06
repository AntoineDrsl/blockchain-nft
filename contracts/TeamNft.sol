// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TeamNft is ERC721, Ownable {

	uint256 public maxSupply = 2;
	uint256 public totalSupply;
	bool public mintEnabled = true;

	struct Avatar {
		string name;
		string img;
		uint256 price;
  	}

  	Avatar[] public avatars;

	mapping (uint => address) public avatarToOwner;
	mapping (address => uint) ownerAvatarCount;

	constructor() payable ERC721("Avatar", "AVT") {
		avatars.push(Avatar("Antoine - Perso", "https://bafybeifa5fvkebqfey3j4zy34fkmw6kakpe6hkreo5mxoxv7b7epadylu4.ipfs.nftstorage.link/", 0.5 ether));
		avatars.push(Avatar("Antoine - Equipe", "https://bafybeigvmron3ldvmmz5sebdy6c5snbqaqpt5yy5al5f3llncdcnuxz6f4.ipfs.nftstorage.link/", 0.5 ether));
		avatars.push(Avatar("Julien - Perso", "https://bafybeideq2vpbmolo7kn2pcrwpfga2vyvfiyryfixvb2zlobwi7liwyfye.ipfs.nftstorage.link/", 0.7 ether));
		avatars.push(Avatar("Julien - Equipe", "https://bafybeieumdywgaaw2l7okihfohl67agfacddhaopfhlkstpkbhdjnxu3my.ipfs.nftstorage.link/", 0.7 ether));
		avatars.push(Avatar("Heddi - Perso", "https://bafybeib7zkwwfrucuxj5yu4epblmvhnuacoefjuvehnxvi7i6zlvwoagz4.ipfs.nftstorage.link/", 0.3 ether));
		avatars.push(Avatar("Heddi - Equipe", "https://bafybeidphwxff5fijqubtgp4a64cqb7s5r6lpyqty2cm6vce3rnmbdoury.ipfs.nftstorage.link/", 0.3 ether));
		avatars.push(Avatar("Yanny - Perso", "https://bafybeibamq2t7322ipvve7y5ds3zjjuadhfv75zkgtw2qm73enwmrrryjm.ipfs.nftstorage.link/", 0.1 ether));
		avatars.push(Avatar("Yanny - Equipe", "https://bafybeihpdyn3cl7jzrdqicmdwopsex3aoph4xdunh2pkra3yabjvblvnn4.ipfs.nftstorage.link/", 0.1 ether));
		avatars.push(Avatar("Thomas - Perso", "https://bafybeibdu6p3hu5b7jf7kpgpppdnvnl6fo3u337e47wkeb3iqle63o7wly.ipfs.nftstorage.link/", 0.2 ether));
		avatars.push(Avatar("Thomas - Equipe", "https://bafybeigib5epolxqemdnzzxgvax7uj5negb6ummnwl44amcldwfj3p53ne.ipfs.nftstorage.link/", 0.2 ether));
		avatars.push(Avatar("Youssef - Perso", "https://bafybeidxyopho3xi5bjp7nc5oj7hewmgiyddbhiybtjst3tzux7rvwgat4.ipfs.nftstorage.link/", 0.9 ether));
		avatars.push(Avatar("Youssef - Equipe", "https://bafybeiav6k3apdiv35xcmo2nqo6jwiuag5e46jj6kejs7dlnzta4icidju.ipfs.nftstorage.link/", 0.9 ether));
		avatars.push(Avatar("Baptiste - Perso", "https://bafybeifnmaw3q3mw7sjudn633unfsadczujzd3b7sbyqywqjjvbitowmei.ipfs.nftstorage.link/", 0.5 ether));
		avatars.push(Avatar("Baptiste - Equipe", "https://bafybeihivfowsofvzflptrjb7ivj33tx74ams7eqmufefslwqfwcw3pyfu.ipfs.nftstorage.link/", 0.5 ether));
		avatars.push(Avatar("Mael - Perso", "https://bafybeiccw4sv5lxodye4gqc7uexe7x242yqzj2r6zrdfaizign5rnhtrte.ipfs.nftstorage.link/", 0.4 ether));
		avatars.push(Avatar("Mael - Equipe", "https://bafybeiaan2hrua2f2bfipb4xhqmtjwrzu4d4tun4ljwvn2bpkbba5xbxeq.ipfs.nftstorage.link/", 0.4 ether));

		totalSupply = avatars.length;
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
		require(msg.value == avatars[_tokenId].price, "Le prix n'est pas le bon.");
		require(avatarToOwner[_tokenId] == address(0x0), "Cet avatar est possede par quelqu'un.");

		ownerAvatarCount[msg.sender]++;
		avatarToOwner[_tokenId] = msg.sender;
		_safeMint(msg.sender, _tokenId);
	}
}