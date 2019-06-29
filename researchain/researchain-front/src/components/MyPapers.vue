<template>
  <v-container grid-list-lg>
    <v-layout
      wrap
      row
    >
      <v-flex xs12>
        <h1 class="display-2 text-xs-center font-weight-bold mb-3">
          My Research Papers
        </h1>
      </v-flex>
      <v-flex xs6 v-for="paper in papers" :key="paper.id">
        <v-card>
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">Title: {{paper[1]}}</h3>
            </div>
          </v-card-title>
          <v-card-text>
            <div>Author: {{paper[2]}}</div>
            <div>Price: {{paper[3]}}</div>
          </v-card-text>
        </v-card>
      </v-flex>
      <v-flex xs12>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" fab fixed bottom right color="teal accent-4" @click="$router.push('add-paper')">
              <v-icon>
                add
              </v-icon>
            </v-btn>
          </template>
          <span>Click here to upload a new paper</span>
        </v-tooltip>
      </v-flex>
    </v-layout>
  </v-container>

</template>

<script>
  export default {
    data: () => ({
      papers: [],
      paperIds: [],
    }),
    methods: {
      async getPaperLength() {
        return this.paperContract.methods.getOwnersPapers(process.env.VUE_APP_ACCOUNT).call().then((response) => this.paperIds = response);
      },
      async getAllPapers() {
        this.papers = [];
        this.getPaperLength().then(() => {
          for (const id of this.paperIds) {
            this.paperContract.methods.getPaper(id).call()
              .then(paper => this.papers.push(paper));
          }
        });
      },
    },
    async created() {
      this.getAllPapers();
    }
  }
</script>
