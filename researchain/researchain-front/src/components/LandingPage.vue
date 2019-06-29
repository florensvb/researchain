<template>
  <v-container>
    <v-layout
      text-xs-center
      wrap
      row
      justify-center
    >
      <v-flex xs12>
        <h1 class="display-2 font-weight-bold mb-3">
          Welcome to Researchain
        </h1>
        <p class="subheading font-weight-regular">
          📚 An easy to use decentralized app for scientific research papers 📚
        </p>
      </v-flex>
      <v-flex xs4>
        <v-btn color="teal accent-4" @click="$router.push('/shop')">
          <span class="mr-2">Take me there</span>
        </v-btn>
      </v-flex>
      <v-flex xs4>
        <v-btn
          color="teal accent-4"
          href="https://github.com/Wandlungskuenstler/Cardano-BLKCHN19"
          target="_blank"
        >
          <span class="mr-2">Show me GitHub</span>
        </v-btn>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    data: () => ({

    })
  }
</script>
