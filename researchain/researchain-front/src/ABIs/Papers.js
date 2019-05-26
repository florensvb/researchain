export default [
  {
    "constant": true,
    "inputs": [
      {
        "name": "_index",
        "type": "uint256"
      }
    ],
    "name": "getPaper",
    "outputs": [
      {
        "name": "title",
        "type": "string"
      },
      {
        "name": "owner",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_title",
        "type": "string"
      }
    ],
    "name": "setTitle",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_title",
        "type": "string"
      }
    ],
    "name": "_createPaper",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
