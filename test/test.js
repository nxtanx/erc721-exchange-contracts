const { accounts, contract } = require('@openzeppelin/test-environment');
const { expect } = require('chai');
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const token = contract.fromArtifact('CharityToken');
const Donate = contract.fromArtifact('Donate');

let charityToken, donate, value = ''

const sender =  accounts[0];
const receiver =  accounts[1];

beforeEach(async function () {

    token = await token.new({ from: sender });
    token = token.address;
    await charityToken.initialize({from : sender}) ;

});

describe("[Testcase 1 : check if the smart contract has been created as set in the variables]", async () => {
 
    
});
  
describe("[Testcase 2 : check if the amount of the token supply has been transffered to the token owner]", async () => {
    
});
  
describe("[Testcase 3: check if the features implemented work as intended]", async () => {

    
  
});
