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

      <v-flex xs12 style="text-align:left">
        <v-btn color="teal accent-4" @click="getAllPapers">
          <span class="mr-2">Get Papers</span>
        </v-btn>
      </v-flex>
      <v-flex  id="papersFlex" style="white-space: nowrap; text-align:left">
          <v-flex xs12>
            <v-card v-for="paper in papers" :key="paper.id">
              <v-card-title primary-title>
                <div>
                  <h3 class="headline mb-0">{{paper[1]}}</h3>
                  <div>{{paper[2]}}</div>
                </div>
              </v-card-title>

              <v-card-actions>
                <v-btn flat color="orange">Share</v-btn>
                <v-btn flat color="orange">Explore</v-btn>
              </v-card-actions>
            </v-card>
          </v-flex>
        </v-flex>
    </v-layout>
  </v-container>

</template>

<script>
  export default {
    data: () => ({
      title: '',
      paperId:'',
      papers: [],
      paperLength: 0,
    }),
    methods: {
      getPaperLength() {
        const length = 2;
        this.paperLength = length;
        return length;
      },

      createPaper() {
        try {
          this.paperContract.methods._createPaper(this.title).send()
            .then(console.log("creating paper done"));
        } catch (e) {
          console.error(e);
        }
      },
      getAllPapers() {
        for (let i = 0; i < this.paperLength; i++) {
          this.paperContract.methods.getPaper(i).call()
            .then(paper => this.papers.push(paper));
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
    async created() {
      await this.getPaperLength();
      this.getAllPapers();
    }
  }
</script>
