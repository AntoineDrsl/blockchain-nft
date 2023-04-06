<template>
  <div class="home">
    {{ error }}
    <button
      v-if="!connected"
      @click="connect"
    >
      Connecter mon porte-feuille
    </button>
    <div v-else>
      Vous êtes connecté !
    </div>
  </div>
</template>

<script setup>
import Web3 from 'web3';
import { ref, onMounted } from 'vue';

const error = ref('');
const connected = ref(false);

function connect() {
  window.ethereum.request({ method: 'eth_requestAccounts' })
    .then(() => {
      connected.value = true; // If users successfully connected their wallet
    });
}

onMounted(() => {
  if (!window.ethereum) {
    error.value = 'Merci d\'installer MetaMask';
  }
});
</script>
