<template>
  <v-container grid-list-lg>
    <v-layout
      wrap
      row
      justify-center
    >
      <v-flex xs12>
        <h1 class="display-2 text-xs-center font-weight-bold mb-3">
          New Research Paper
        </h1>
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
        <v-btn color="teal accent-4" :loading="loading" @click="$refs.inputUpload.click()">Upload PDF</v-btn>
        <input v-show="false" ref="inputUpload" type="file" accept="application/pdf" @change="saveToIpfsWithFilename">
      </v-flex>
      <v-flex xs2>
        <v-btn color="teal accent-4" :loading="loading" @click="createPaper" :disabled="!validInput">
          <span class="mr-2">Create Paper</span>
        </v-btn>
      </v-flex>
      <v-flex xs12>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" fab fixed bottom right color="teal accent-4" @click="$router.push('shop')">
              <v-icon>
                arrow_back
              </v-icon>
            </v-btn>
          </template>
          <span>Click here to go back</span>
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
      title: '',
      author: '',
      price: 0,
      hash: '',
      loading: false,
      snackbar: false,
      snackbarText: '',
    }),
    computed: {
      validInput() {
        return this.title.length > 0 && this.author.length > 0 && this.price.length > 0 && this.hash.length > 0;
      },
    },
    methods: {
      async createPaper() {
        try {
          this.loading = true;
          this.paperContract.methods.createPaper(this.title, this.author, parseFloat(this.price), this.hash).send()
            .on('transactionHash', () => {
              this.snackbarText = `Congratulations on adding ${this.title} by ${this.author}`;
              this.snackbar = true;
              this.loading = false;
            })
            .on('error', (e) => {
              this.snackbarText = 'Something went wrong 😑';
              this.snackbar = true;
              this.loading = false;
              console.error(e);
            });
        } catch (e) {
          console.error(e);
        }
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
  }
</script>
