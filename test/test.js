const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const FactoryContract = contract.fromArtifact('FactoryContract');
const Exchange = contract.fromArtifact('Exchange');

let factoryContract, exchangeContract;

const sender =  accounts[0];

const company1 =  accounts[1];
const company2 =  accounts[2];
const company3 =  accounts[3];

beforeEach(async function () {

    factoryContract = await FactoryContract.new({ from: sender });
    factoryContractAddress = factoryContract.address;
    await factoryContract({from : sender}) ;

});

describe("[Testcase 1 : check if the smart contract has been created as set in the variables]", async () => {
 
    
});
  
describe("[Testcase 2 : check if the amount of the token supply has been transffered to the token owner]", async () => {
    
});
  
describe("[Testcase 3: check if the features implemented work as intended]", async () => {

    
  
});
