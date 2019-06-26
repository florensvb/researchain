<template>
  <v-container grid-list-md>
    <v-layout
      wrap
      row
      justify-center
    >
      <v-flex xs12>
        <h1 class="display-2 font-weight-bold mb-3">
          Researchain Shop
        </h1>
      </v-flex>
      <v-flex xs12>
        <v-card v-for="paper in papers" :key="paper.id">
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">{{paper[1]}}</h3>
            </div>
          </v-card-title>
          <v-card-text>
            <div>{{paper[2]}}</div>
            <div>{{paper[3]}}</div>
            <div>{{paper[4]}}</div>
          </v-card-text>
        </v-card>
      </v-flex>
      <v-flex xs3>
        <v-text-field
          label="Title"
          box
          v-model="title"
        ></v-text-field>
      </v-flex>
      <v-flex xs3>
        <v-text-field
          label="Author"
          box
          v-model="author"
        ></v-text-field>
      </v-flex>
      <v-flex xs3>
        <v-text-field
          label="Price"
          box
          v-model="price"
        ></v-text-field>
      </v-flex>
      <v-flex xs3>
        <v-text-field
          label="Hash"
          box
          disabled
          v-model="hash"
        ></v-text-field>
      </v-flex>
      <v-flex xs2>
        <v-btn color="teal accent-4" @click="$refs.inputUpload.click()">Upload PDF</v-btn>
        <input v-show="false" ref="inputUpload" type="file" accept="application/pdf" @change="saveToIpfsWithFilename">
      </v-flex>
      <v-flex xs2>
        <v-btn color="teal accent-4" @click="createPaper" :disabled="!validInput">
          <span class="mr-2">Create Paper</span>
        </v-btn>
      </v-flex>
    </v-layout>
  </v-container>

</template>

<script>
  export default {
    data: () => ({
      title: '',
      author: '',
      price: 0,
      hash: '',
      paperId:'',
      papers: [],
      paperLength: 0,
    }),
    computed: {
      validInput() {
        return this.title.length > 0 && this.author.length > 0 && this.price.length > 0 && this.hash.length > 0;
      },
    },
    methods: {
      async getPaperLength() {
        return this.paperContract.methods.getPapersCount().call().then((response) => this.paperLength = response);
      },

      async createPaper() {
        try {
          this.paperContract.methods.createPaper(this.title, this.author, parseFloat(this.price), this.hash).send();
          setTimeout(() => this.getAllPapers(), 2000);
        } catch (e) {
          console.error(e);
        }
      },
      async getAllPapers() {
        console.log('Getting papers');
        this.getPaperLength().then(() => {
          for (let i = 0; i < this.paperLength; i++) {
            this.paperContract.methods.getPaper(i).call()
              .then(paper => this.papers.push(paper));
          }
          this.title = '';
          this.author = '';
          this.price = 0;
          this.hash = '';
        });
      },
      async saveToIpfsWithFilename ({ target: { files }}) {
        try {
          const file = [...files][0];
          const fileDetails = {
            path: file.name,
            content: file
          };
          const options = {
            wrapWithDirectory: true,
            progress: (prog) => console.log(`received: ${prog}`)
          };
          const response = await this.ipfs.add(fileDetails, options);
          const fileHash = response[response.length - 1].hash;
          this.hash = fileHash;
          console.log(`File hash: ${fileHash}`);
        } catch (e) {
          console.error(e);
        }
      }
    },
    async created() {
      this.getAllPapers();
    }
  }
</script>
