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
        <v-btn color="teal accent-4" @click="qetSomePaper">
          <span class="mr-2">Get Papers</span>
        </v-btn>
      </v-flex>
      <v-flex  id="papersFlex" style="white-space: nowrap; text-align:left">
        <v-flex style="display:none" id="emptyFlex">
          <v-flex xs12 md4 sm6 style="display:inline-block;margin-right: 30px;" >
            <v-card>
              <v-img
                      src= 'https://cdn.vuetifyjs.com/images/cards/desert.jpg'
                      aspect-ratio="2.75"
              ></v-img>

              <v-card-title primary-title>
                <div>
                  <h3 class="headline mb-0">##title##</h3>
                  <div >Kangaroo Valley Safari</div>
                </div>
              </v-card-title>

              <v-card-actions>
                <v-btn flat color="orange">Share</v-btn>
                <v-btn flat color="orange">Explore</v-btn>
              </v-card-actions>
            </v-card>

          </v-flex>
        </v-flex>



      </v-flex>
    </v-layout>
  </v-container>

</template>

<script>
  function showPaper(paper){
    console.log(paper);
    var text = document.getElementById('emptyFlex').innerHTML;
    text = text.replace("##title##",paper.title).replace('##imageUrl##','');

    var papersFlex = document.getElementById('papersFlex');
    papersFlex.innerHTML+=text;
  }

  export default {
    data: () => ({
      title: '',
      paperId:''
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
      qetSomePaper(){
        try{
          var papersLen=2;//this.papers.methods.lenPaper().call().then(console.log);
          var i;
          for(i=0;i<papersLen;i++) {
            this.papers.methods.getPaper(i).call().then(showPaper);
          }

        }
        catch(e){
          console.error(e)
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
