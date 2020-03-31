const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FactoryContract = contract.fromArtifact('FactoryContract');
const ERC721Contract = contract.fromArtifact('ERC721');
const Exchange = contract.fromArtifact('Exchange');

let factoryContract, exchangeContract;

const factoryOwner =  accounts[0];

const company1 =  accounts[1];
const company2 =  accounts[2];
const company3 =  accounts[3];

let name = 'Company ABC Token';
let symbol = 'ABCTK';
let owner = company1;
let deployedFactoryInstance, deployedTokenInstance, deployedExchangeInstance, tokenOwnerAddress = '';

beforeEach(async function () {

  exchangeContract = await Exchange.new({from : factoryOwner});

  factoryContract = await FactoryContract.new({ from: factoryOwner });
  deployedFactoryInstance = await factoryContract.create(name , symbol , owner ,{from : owner});

  tokenOwnerAddress = await factoryContract.getContract(0)
  deployedTokenInstance = await ERC721Contract.at(tokenOwnerAddress);

});

describe("[Testcase 1 : check if the token deployed has been created as set in the variables]", async () => {
  it('Token Name is ' + name, async function () {
    let testName = await deployedTokenInstance.getName();
    expect(testName).to.equal(name);
  });
  it('Token Name Symbol is' + symbol, async function () {
    let testSymbol = await deployedTokenInstance.getSymbol();
    expect(testSymbol).to.equal(symbol);
  });
  it('Token owner is ' + tokenOwnerAddress, async function () {
    let testOwner = await deployedTokenInstance.owner();
    expect(testOwner).to.equal(owner);
  });
});
  
describe("[Testcase 2 : check if the amount of the token supply has been transffered to the token owner]", async () => {
  // const totalSupply = await myContract.totalSupply();
  // let totalSupplyNumber = new BN(totalSupply).toString();
  // const ownerBalance = await myContract.balanceOf(owner);
  // let ownerBalanceNumber = new BN(ownerBalance).toString();

  // expect (ownerBalanceNumber).to.equal(totalSupplyNumber);
});
  
// describe("[Testcase 3: check if the features implemented work as intended]", async () => {

    
  
// });
