pragma solidity >=0.4.21 <0.6.0;

/// @title Researchain Paper contract
contract Papers {
    
    mapping (string => bool) Titles;
    
    // This represents a single paper
    struct Paper {
        string title;
        address owner;
    }
    
    Paper[] private papers;

    function getPaper(uint _index) public view returns (string memory title, address owner) {
        return (papers[_index].title, papers[_index].owner);
    }

    function lenPaper() public view returns(uint len){
	return (papers.length);
    }
    function setTitle(string memory _title) public {
        Titles[_title] = true;
    }
    
    function titleExists(string memory _title) private returns (bool) {
        return Titles[_title];
    }
    
    function _createPaper(string memory _title) public {
        require(!titleExists(_title), "A paper with this title already exists, dude.");
        setTitle(_title);
        papers.push(Paper(_title, msg.sender));
    }
}
