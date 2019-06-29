<template>
  <v-app dark>
    <v-toolbar app>
      <v-toolbar-title class="headline text-uppercase">
        <span>Researchain</span>
        <span class="font-weight-light"> Technische Universität Berlin</span>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn flat @click="$router.push('my-papers')">
        <span class="mr-2">My Papers</span>
      </v-btn>
    </v-toolbar>
    <v-content>
      <router-view/>
    </v-content>
  </v-app>
</template>

<script>

export default {
  name: 'App',
  components: {
  },
  data () {
    return {
      //
    }
  }
}
</script>
