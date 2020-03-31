pragma solidity "0.6.0";

import "./ERC721.sol";

contract FactoryContract{
    
    mapping(address => address) public contractOwners;
    
    uint256 tokenCount = 0;

    mapping(uint256=>address) public tokenAddresses;

    function create(string memory name,string memory symbol,address owner) public returns(address newContract){
        ERC721 token = new ERC721(name,symbol,owner);
        contractOwners[address(token)] = owner;
        tokenAddresses[tokenCount++] = address(token);
        return address(token);
    }
    
}