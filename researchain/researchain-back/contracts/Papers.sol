// new version from Papers.sol
pragma solidity >=0.4.21 <0.6.0;

import "./ownable.sol";

/// @title Researchain Paper contract
contract Papers is Ownable {

    event NewPaper(uint paperId, string title, string hash);
    event PaperBought(uint paperId, string title, string hash);

    struct Paper {
        string title;
        string author;
        uint price;
        string hash;   // hash is the IPFS address to the file
        address payable owner;
    }

    Paper[] private papers;

    mapping (uint => address) public paperIdToOwner;
    mapping (address => uint) ownerPaperCount;
    mapping (address => uint[]) public ownersPaperIds;

    // createPaper gets called by JavaScript with values
    function _createPaper(string memory _title, string memory _author, uint _price, string memory _hash) public {
        uint id = papers.push(Paper(_title, _author, _price, _hash, msg.sender)) - 1;
        paperIdToOwner[id] = msg.sender;
        ownerPaperCount[msg.sender]++;
        ownersPaperIds[msg.sender].push(uint(id)); // working?
        emit NewPaper(id, _title, _hash);
    }

    function changePaperPrice(uint _id, uint _newPrice) public onlyOwner {
      papers[_id].price = _newPrice; // only owner can change the price of the paper
    }

    function getPaper(uint _id) public view returns (uint, string memory, string memory, uint, string memory, address) {
        return (_id, papers[_id].title, papers[_id].author, papers[_id].price, papers[_id].hash, papers[_id].owner);
    }

    function buyPaper(uint _id) external payable {
      require(msg.value >= papers[_id].price);

      // caller sends value to contract according papers[id].price
      bool transferConfirmed = msg.sender.send(papers[_id].price);

      // transfer papers[id].hash to caller, if paid
      if (transferConfirmed == true) emit PaperBought(_id, papers[_id].title, papers[_id].hash);

      withdraw(_id); // withdraw value to owner -> see function withdraw ?
    }

    // PaperStore needs to point to contract on Ethereum
    // JS Code:
    // PaperStore.buyPaper({from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001)})
    function withdraw(uint _id) public onlyOwner {
      address payable owner = papers[_id].owner;
      owner.transfer(address(this).balance);
    }
}
