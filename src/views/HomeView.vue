<template>
  <nav class="navbar navbar-dark bg-dark justify-content-between mb-3">
    <a class="navbar-brand text-white">Gallerie des avatars du groupe 2</a>
    <form v-if="!noProvider" class="form-inline">
      <button v-if="!connected" class="btn btn-outline-white my-2 my-sm-0" @click.prevent="connect">
        Connecter mon wallet
      </button>
      <div v-else class="text-white my-2 my-sm-0">
        Compte connecté: {{ currentAccount }}
      </div>
    </form>
  </nav>
  <div class="home">
    <div v-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <div>
      <div class="container">
        <div class="row">
          <div
            v-for="(avatar, i) in avatars"
            :key="i"
            class="col-sm-4 mb-2"
          >
            <div class="card mx-2">
              <img class="card-img-top" :src="avatar.img" :alt="avatar.name">
              <div class="card-body">
                <h5 class="card-title">{{ avatar.name }}</h5>
                <p class="card-text">Prix: {{ web3.utils.fromWei(avatar.price, "ether") }} ETH</p>
                <button v-if="!avatar.mintMessage && connected" class="btn btn-primary" @click="mint(i, avatar.price)">
                  Acheter
                </button>
                <div v-else-if="connected">
                  {{ avatar.mintMessage }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Web3 from 'web3';
import { ref, onMounted } from 'vue';
import { abi } from '@/assets/TeamNft.json';

const CONTRACT_ADDRESS = process.env.VUE_APP_CONTRACT_ADDRESS;
let web3;
let contract;

const error = ref('');
const connected = ref(false);
const avatars = ref([]);
const currentAccount = ref('');
const noProvider = ref(false);

async function getNft() {
  web3 = new Web3(window.ethereum);
  contract = new web3.eth.Contract(abi, CONTRACT_ADDRESS);
  avatars.value = [];

  const totalSupply = await contract.methods.totalSupply().call();
  for (let i = 0; i < totalSupply; i += 1) {
    const owner = await contract.methods.avatarToOwner(i).call();
    let mintMessage = null;
    if (owner.toLowerCase() === window.ethereum.selectedAddress) {
      mintMessage = 'Cet avatar vous appartient';
    } else if (owner !== '0x0000000000000000000000000000000000000000') {
      mintMessage = 'Cet avatar a déjà été acheté';
    }

    const avatar = {
      mintMessage,
      ...await contract.methods.avatars(i).call(),
    };
    avatars.value.push(avatar);
  }
}

function connect() {
  if (window.ethereum.selectedAddress) {
    return;
  }
  window.ethereum.request({ method: 'eth_requestAccounts' })
    .then(() => {
      connected.value = true;
    });
}

async function mint(avatarId, price) {
  try {
    error.value = '';
    await contract.methods.mint(avatarId).send({
      from: window.ethereum.selectedAddress,
      value: price,
    });
    await getNft();
  } catch (err) {
    if (err.message.startsWith("[ethjs-query] while formatting outputs from RPC '")) {
      let formattedErr = err.message.replace("[ethjs-query] while formatting outputs from RPC '", '');
      formattedErr = formattedErr.substring(0, formattedErr.length - 1);
      error.value = JSON.parse(formattedErr).value.data.data.reason;
    } else {
      error.value = 'Une erreur est survenue, vous n\'avez pas été débité.';
    }
  }
}

onMounted(() => {
  if (!window.ethereum) {
    error.value = 'Merci d\'installer MetaMask';
    noProvider.value = true;
    return;
  }

  // Listen account change
  window.ethereum.on('accountsChanged', (accounts) => {
    if (!accounts.length) {
      connected.value = false;
    }
    currentAccount.value = accounts.length ? accounts[0] : '';
    getNft();
  });

  // Check if already connected
  setTimeout(() => {
    if (window.ethereum.selectedAddress) {
      currentAccount.value = window.ethereum.selectedAddress;
      connected.value = true;
    }
  }, 500);

  // Launch NFT
  getNft();
});
</script>
