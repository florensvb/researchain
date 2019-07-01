<template>
  <v-container grid-list-lg>
    <v-layout
      wrap
      row
    >
      <v-flex xs12>
        <h1 class="display-2 text-xs-center font-weight-bold mb-3">
          Papers I wrote
        </h1>
      </v-flex>
      <v-flex xs12 v-for="paper in papers" :key="paper.id">
        <v-card hover>
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">Title: {{paper[1]}}</h3>
            </div>
          </v-card-title>
          <v-spacer/>
          <v-card-text>
            <div>Author: {{paper[2]}}</div>
            <div>Price: {{`${paper[3]} ETH`}}</div>
          </v-card-text>
          <v-card-actions>
            <v-flex xs12>
              <v-btn color="teal accent-4" @click="downloadPaper(paper[4])">
                <v-icon>cloud_download</v-icon>
              </v-btn>
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-flex>
      <v-flex xs12 text-xs-center v-if="!papers.length">
        {{ `So much empty. Get writing ✏️` }}
      </v-flex>
      <v-flex xs12>
        <h1 class="display-2 text-xs-center font-weight-bold mb-3">
          Papers I purchased
        </h1>
      </v-flex>
      <v-flex xs12 v-for="paper in ownedPapers" :key="paper.id">
        <v-card hover>
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">Title: {{paper[1]}}</h3>
            </div>
          </v-card-title>
          <v-spacer/>
          <v-card-text>
            <div>Author: {{paper[2]}}</div>
            <div>Price: {{`${paper[3]} ETH`}}</div>
          </v-card-text>
          <v-card-actions>
            <v-flex xs12>
              <v-btn color="teal accent-4" @click="downloadPaper(paper[4], true)">
                <v-icon>cloud_download</v-icon>
              </v-btn>
            </v-flex>
          </v-card-actions>
        </v-card>
      </v-flex>
      <v-flex xs12 text-xs-center v-if="!ownedPapers.length">
        {{ `So much empty. Get buying 🛒️` }}
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
          @click="snackbar = false"
        >
          Dismiss
        </v-btn>
      </v-snackbar>
    </v-layout>
  </v-container>
</template>

<script>
  import * as fileDownload from 'js-file-download';

  export default {
    data: () => ({
      papers: [],
      ownedPapers: [],
      paperIds: [],
      ownedPaperIds: [],
      snackbarText: '',
      snackbar: false,
    }),
    methods: {
      async downloadPaper(hash) {
        try {
          this.ipfs.get(hash, function (err, files) {
            if (err) return;
            fileDownload(files[1].content, files[1].path.split('/')[1]);
          })
        } catch (e) {
          console.error(e);
        }
      },
      async getPaperLength() {
        return this.paperContract.methods.getOwnersPapers(this.web3.defaultAccount).call()
          .then(response => this.paperIds = response)
          .catch(() => {
            this.snackbarText = 'Looks like you have not written any papers yet 😖';
            this.snackbar = true;
          });
      },
      async getOwnedPaperLength() {
        return this.paperContract.methods.getBuyersPapers(this.web3.defaultAccount).call()
          .then(response => this.ownedPaperIds = response)
          .catch(() => {
            this.snackbarText = 'Looks like you dont own any papers yet 😖';
            this.snackbar = true;
          });
      },
      async getAllPapers() {
        this.papers = [];
        this.getPaperLength().then(() => {
          for (const id of this.paperIds) {
            this.paperContract.methods.getPaper(id).call()
              .then(paper => this.papers.push(paper))
          }
        });
      },
      async getAllBoughtPapers() {
        this.papers = [];
        this.getOwnedPaperLength().then(() => {
          for (const id of this.ownedPaperIds) {
            this.paperContract.methods.getPaper(id).call()
              .then(paper => this.ownedPapers.push(paper))
          }
        });
      },
    },
    async created() {
      this.getAllPapers();
      this.getAllBoughtPapers();
    }
  }
</script>
