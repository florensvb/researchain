<template>
  <v-container grid-list-lg>
    <v-layout
      wrap
      row
    >
      <v-flex xs12>
        <h1 class="display-2 text-xs-center font-weight-bold mb-3">
          Available Research Papers
        </h1>
      </v-flex>
      <v-flex xs12 v-for="paper in papers" :key="paper.id">
        <v-card hover>
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">Title: {{paper[1]}}</h3>
            </div>
          </v-card-title>
          <v-card-text>
            <div>Author: {{paper[2]}}</div>
            <div>Price: {{`${paper[3]} ETH`}}</div>
          </v-card-text>
          <v-card-actions>
            <v-flex xs12>
              <v-btn color="teal accent-4" @click="buyPaper(paper[0], paper[3], paper[1], paper[2])" :disabled="alreadyOwn(paper)">
                <v-icon>shopping_cart</v-icon>
              </v-btn>
            </v-flex>
          </v-card-actions>
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
      <v-snackbar
        v-model="snackbar"
        bottom
        :timeout="6000"
      >
        {{ snackbarText }}
        <v-btn
          color="pink"
          flat
          @click="$router.push('shop')"
        >
          Show me
        </v-btn>
      </v-snackbar>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    data: () => ({
      papers: [],
      paperLength: 0,
      snackbar: false,
      snackbarText: '',
      loading: false,
    }),
    methods: {
      async getPaperLength() {
        return this.paperContract.methods.getPapersCount().call().then((response) => this.paperLength = response);
      },
      async getAllPapers() {
        this.papers = [];
        this.getPaperLength().then(() => {
          for (let i = 0; i < this.paperLength; i++) {
            this.paperContract.methods.getPaper(i).call()
              .then(paper => this.papers.push(paper));
          }
        });
      },
      async buyPaper(id, price, title, author) {
        this.loading = true;
        this.paperContract.methods.buyPaper(id).send({ value: this.web3.utils.toWei(price.toString(), "ether")})
          .on('receipt', () => {
            this.snackbarText = `Congratulations on buying ${title} by ${author}`;
            this.snackbar = true;
            this.loading = false;
          })
          .on('error', (e) => {
            this.snackbarText = 'Something went wrong 😑';
            this.snackbar = true;
            this.loading = false;
            console.error(e);
          });
      },
      alreadyOwn(paper) {
        return paper[5] === this.web3.defaultAccount;
      }
    },
    async created() {
      this.getAllPapers();
    }
  }
</script>
