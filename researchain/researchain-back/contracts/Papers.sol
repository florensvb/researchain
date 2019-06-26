// new version from Papers.sol
pragma solidity >=0.5.0;

import "./Ownable.sol";

/// @title Researchain Paper contract
contract Papers is Ownable {

    event NewPaper(uint paperId, string title, string hash);
    event PaperBought(address buyer, uint paperId, string title, string hash);
    event EtherTransfered(address owner, uint value);

    struct Paper {
        string title;
        string author;
        uint price;
        string hash;   // hash is the IPFS address to the file
        address payable owner;
    }

    Paper[] private papers;

    uint numberOfPapers = 0;
    mapping (uint => address) public paperIdToOwner; // shows the owner of an paperId
    mapping (address => uint) ownerPaperCount; // number of papers an owner has
    mapping (address => uint[]) public ownersPaperIds; // all PaperId's of an owner address
    mapping (address => bool) public ownerExist; // shows that owner has uploaded a paper
    mapping (address => bool) public buyerExist; // shows that buyer already bought something
    mapping (address => uint[]) public buyersPaperIds; // all PaperId's bought by a buyer address

    // createPaper gets called by JavaScript with values
    function createPaper(string memory _title, string memory _author, uint _price, string memory _hash) public returns (uint, string memory, string memory, uint, string memory, address) {
        uint id = papers.push(Paper(_title, _author, _price, _hash, msg.sender)) - 1;
        paperIdToOwner[id] = msg.sender;
        ownerPaperCount[msg.sender]++;
        ownersPaperIds[msg.sender].push(uint(id)); // working?
        ownerExist[msg.sender] = true;
        numberOfPapers++;
        emit NewPaper(id, _title, _hash);
        return getPaper(id);
    }

    function changePaperPrice(uint _id, uint _newPrice) public onlyOwner {
      papers[_id].price = _newPrice; // only owner can change the price of the paper
    }

    function getPapersCount() public view returns (uint) {
        return papers.length;
    }

    function getPaper(uint _id) public view returns (uint, string memory, string memory, uint, string memory, address) {
        require(_id < papers.length, "id does not exist");
        return (_id, papers[_id].title, papers[_id].author, papers[_id].price, papers[_id].hash, papers[_id].owner);
    }

    function getOwnersPapers(address _owner) public view returns (uint[] memory) {
        require(ownerExist[_owner], "Owner has no Papers!");
        return (ownersPaperIds[_owner]);
    }

    function getBuyersPapers(address _owner) public view returns (uint[] memory) {
        require(buyerExist[_owner], "Buyer bought no Papers!");
        return (buyersPaperIds[_owner]);
    }

    function buyPaper(uint _id) external payable {
      require(numberOfPapers > _id, "paper id does not exist!");
      require(msg.value >= papers[_id].price, "not sufficient funds added to buyPaper function call!");

      // caller sends value to contract according papers[id].price
      bool transferConfirmed = msg.sender.send(papers[_id].price);

      // transfer papers[id].hash to caller, if paid
      if (transferConfirmed == true) emit PaperBought(msg.sender, _id, papers[_id].title, papers[_id].hash);

      buyerExist[msg.sender] = true;
      buyersPaperIds[msg.sender].push(uint(_id)); // push bought paperId on buyers account

      _withdraw(_id); // withdraw value to owner -> see function withdraw ?
    }

    // PaperStore needs to point to contract on Ethereum
    // JS Code:
    // PaperStore.buyPaper({from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001)})
    function _withdraw(uint _id) internal onlyOwner {
      address payable owner = papers[_id].owner;
      owner.transfer(address(this).balance);
      emit EtherTransfered(owner, address(this).balance);
    }
}
