pragma solidity "0.6.0";

interface IERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approved, uint256 _tokenId) external ;
    function transfer(address _to, uint256 _tokenId) external;
    function mint(uint256 quantity) external ;
    function totalSupply() external view returns(uint);
}

library SafeMath {
/**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
        return 0;
        }
    c = a * b;
        assert(c / a == b);
        return c;
    }
    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }
    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Ownable {
  address public  owner;
  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}

contract ERC721 is IERC721,Ownable  {
    using SafeMath for uint256; 
    
    // Mapping from token ID to owner
      mapping (uint256 => address) internal tokenOwner;
    // Mapping from token ID to approved address
      mapping (uint256 => address) internal tokenApprovals;
    // Mapping from owner to number of owned token
      mapping (address => uint256) internal ownedTokensCount;
    //   mapping (address => mapping (address => bool)) internal operatorApprovals;
      string public name;
      string public symbol;
      uint256 tokenId = 0;
      
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }
    modifier canTransfer(uint256 _tokenId) {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }
    
    constructor(string memory _name, string memory _symbol, address _address) public {
        name = _name;
        symbol = _symbol;
        owner = _address;
    }
    
    function getName() public view returns(string memory){
        return name;
    }
    
    function getSymbol() public view returns(string memory){
        return symbol;
    }
      
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0));
        return ownedTokensCount[_owner];
    }
    
    function totalSupply() external view override returns(uint){
        return 123;
    }
    
    function transfer(address _to, uint256 _tokenId) canTransfer(_tokenId) external override {
        require(_to != address(0) );
        removeTokenFrom(msg.sender, _tokenId);
        addTokenTo(_to, _tokenId);
    }
    
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }
    
    function exists(uint256 _tokenId) public view returns (bool) {
        address owner = tokenOwner[_tokenId];
        return owner != address(0);
    }
    
    function approve(address _to, uint256 _tokenId) public override {
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        require(msg.sender == owner);
        tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }
    
    function getApproved(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) canTransfer(_tokenId) public override {
        require(_from != address(0));
        require(_to != address(0));
        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
    }
    
    function mint(uint256 quantity) public onlyOwner override {
        require(quantity > 0);
	for (uint256 i=0; i < quantity; i++) {
            addTokenTo(msg.sender, tokenId);
	    tokenId++;   
        }
    }
    
    function _burn(address _owner, uint256 _tokenId) internal {
        clearApproval(_owner, _tokenId);
        removeTokenFrom(_owner, _tokenId);
        emit Transfer(_owner, address(0), _tokenId);
    }

    function clearApproval(address _owner, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _owner);
        if (tokenApprovals[_tokenId] != address(0)) {
            tokenApprovals[_tokenId] = address(0);
        }
    }
    
      function addTokenTo(address _to, uint256 _tokenId) internal {
        require(tokenOwner[_tokenId] == address(0));
        tokenOwner[_tokenId] = _to;
        ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
      }
      
      function removeTokenFrom(address _from, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from);
        ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
        tokenOwner[_tokenId] = address(0);
      }
  
      function isApprovedOrOwner(
        address _spender,
        uint256 _tokenId
      )
        internal
        view
        returns (bool)
      {
        address owner = ownerOf(_tokenId);
        return (
          _spender == owner ||
          getApproved(_tokenId) == _spender
        );
      }
  
}
