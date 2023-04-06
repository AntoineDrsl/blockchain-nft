# blockchain-nft

## Groupe 2

Antoine Durussel, Julien Dupont, Thomas Leux, Mael Bourdeleix, Baptiste Ménard, Yanny Ouzid, Heddi Brahiti

## Preproduction link

https://blockchain-nft-group2.netlify.app/

## Installation

### Install packages
```
yarn install
```

### Launch frontend
```
yarn serve
```

### In production
- Update VUE_APP_CONTRACT_ADDRESS with contract address 0xbedc5f86851a691B881f12c5C9f1dcf6ef43C277 (and relaunch ```yarn install```)
- Select "Mumbai" network in Metamask

### With Ganache
```
truffle migrate --network development --reset all
```
- Update VUE_APP_CONTRACT_ADDRESS with new contract address (and relaunch ```yarn install```)
- Select "Ganache" network in Metamask

### Use application
In our application you can :
- Connect your wallet and change account without reload
- View all avatars of the gallery
- See if an avatar is owned by you or someone else
- Mint an avatar (only 2 by person !)
