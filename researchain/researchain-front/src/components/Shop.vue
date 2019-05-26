<template>
  <v-container>
    <v-layout
      text-xs-center
      wrap
    >
      <v-flex mb-4>
        <h1 class="display-2 font-weight-bold mb-3">
          Researchain Shop
        </h1>
      </v-flex>
      <v-flex xs12>
        <v-btn color="teal accent-4" @click="$router.push('/shop')">
          <span class="mr-2">Upload Paper</span>
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
