<template>
  <v-container>
    <v-layout
      text-xs-center
      wrap
    >
      <v-flex xs12>
        <v-img
          :src="require('../assets/logo.svg')"
          class="my-3"
          contain
          height="200"
        ></v-img>
      </v-flex>

      <v-flex mb-4>
        <h1 class="display-2 font-weight-bold mb-3">
          Welcome to Researchain
        </h1>
        <p class="subheading font-weight-regular">
          An easy to use Blockchain for scientific papers 📚
        </p>
      </v-flex>
      <v-flex xs12>
        <v-btn color="teal accent-4" @click="$router.push('/shop')">
          <span class="mr-2">Shop</span>
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
