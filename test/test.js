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
const acc1 =  accounts[2];
const acc2 =  accounts[3];

let name = 'Company ABC Token';
let symbol = 'ABCTK';
let owner = company1;
let deployedFactoryInstance, deployedTokenInstance, deployedExchangeInstance, tokenOwnerAddress = '';

let amount =0;

before(async function () {

  exchangeContract = await Exchange.new({from : factoryOwner});

  factoryContract = await FactoryContract.new({ from: factoryOwner });
  deployedFactoryInstance = await factoryContract.create(name , symbol , owner ,{from : owner});

  tokenOwnerAddress = await factoryContract.getContract(0)
  deployedTokenInstance = await ERC721Contract.at(tokenOwnerAddress);

});

describe("[Testcase 1 : check if the token deployed has been created and working as expected.]", async () => {
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

  it('Token Minted from TokenOwner is same as created' + tokenOwnerAddress, async function () {
    await deployedTokenInstance.mint(5, {from : owner});
    amount = await deployedTokenInstance.balanceOf(owner);
    amount = new BN(amount).toString();
    expect(amount).to.equal('5');
  });

  it('Succesful Token transfer to address' + tokenOwnerAddress, async function () {
    await deployedTokenInstance.transfer(acc1, 4, {from : owner});
    let acc1Amount = await deployedTokenInstance.balanceOf(acc1);
    acc1Amount = new BN(acc1Amount).toString();
    expect(acc1Amount).to.equal('1');
  });

});
