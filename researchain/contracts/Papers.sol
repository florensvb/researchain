pragma solidity >=0.4.21 <0.6.0;

/// @title Researchain Paper contract
contract Papers {
    
    mapping (string => bool) Titles;
    
    // This represents a single paper
    struct Paper {
        string title;
        address owner;
    }
    
    Paper[] public papers;

    
    function setTitle(string memory _title) public {
        Titles[_title] = true;
    }
    
    function titleExists(string memory _title) private returns (bool) {
        return Titles[_title];
    }
    
    function _createPaper(string memory _title) public {
        require(!titleExists(_title));
        papers.push(Paper(_title, msg.sender));
    }
}
