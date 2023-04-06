<template>
  <div class="home">
    <div v-if="error" class="alert alert-danger">
      {{ error }}
    </div>
    <button
      v-if="!connected"
      @click="connect"
    >
      Connecter mon porte-feuille
    </button>
    <div v-else>
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
                <a v-if="!avatar.mintMessage" href="#" class="btn btn-primary" @click="mint(i, avatar.price)">
                  Mint now
                </a>
                <div v-else>
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

const CONTRACT_ADDRESS = '0xf0fc8aE8B75c58AFEAe31C7C3C803aAB9AE5ad09';
let web3;
let contract;

const error = ref('');
const connected = ref(false);
const avatars = ref([]);

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
  window.ethereum.request({ method: 'eth_requestAccounts' })
    .then(() => {
      connected.value = true; // If users successfully connected their wallet
      getNft();
      window.ethereum.on('accountsChanged', () => {
        getNft();
      });
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
  }
});
</script>
