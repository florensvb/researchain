<template>
  <v-container>
    <v-layout
      text-xs-center
      wrap
      row
    >
      <v-flex xs12>
        <h1 class="display-2 font-weight-bold mb-3">
          Researchain Shop
        </h1>
      </v-flex>
      <v-flex>
        <v-text-field
          label="Title"
          single-line
          box
          v-model="title"
        ></v-text-field>
      </v-flex>
      <v-flex>
        <v-btn color="teal accent-4" @click="createPaper">
          <span class="mr-2">Upload Paper</span>
        </v-btn>
      </v-flex>
      <v-flex xs12>
        <v-btn @click="$refs.inputUpload.click()">Upload File</v-btn>
        <input v-show="false" ref="inputUpload" type="file" accept="application/pdf" @change="saveToIpfsWithFilename" >
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
  export default {
    data: () => ({
      title: '',
    }),
    methods: {
      createPaper() {
        try {
          this.papers.methods._createPaper(this.title).send()
            .then(console.log("creating paper done"));
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
          console.log(`File hash: ${fileHash}`);
        } catch (e) {
          console.error(e);
        }
      }
    },
    created() {
      // this.ipfs.g
    }
  }
</script>
