pragma solidity ^0.5.0;

// Importing required contracts.
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

//Initialising the contract.
// The contract is iniatialised as a OWnable contract to inherit and grant the basic authorization control functions which simplifies the implementation of "user permissions".
contract StakingToken is ERC20, Ownable {
    // Inheriting the properties of SafeERC20 withing the contract
    using SafeMath for uint256;
    // Creating a golbal variable to hold the information about the stakeholders.
    address[] internal stakeholders;
    // Mapping stakes with respect to each stakeholder.
    mapping(address => uint256) internal stakes;
    // Mapping rewards for each stakeholder and their rewards.
    mapping(address => uint256) internal rewards;
    // Initialising a constructor for the staking Token
    //Start of the constructor.
    constructor(address _owner, uint256 _supply) public{ 
        // _owner holds the address of the constructor and _supply holds the value of number of tokens to be minted.  
        _mint(_owner, _supply);

    }// End of Constructor.
    // Start of the function createStake.
    // _stake holds the value of stake to be created. 
    function createStake(uint256 _stake) public
    {
        _burn(msg.sender, _stake);
        // If the staked amount in the users amount is equal to zero, then the user will be added using addStakeholder function.
        //addStakeholder takes the address of the user as an argument using msg.sender. 
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        // If the user already has his funds staked then the below code is executed to further add the stakes.
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }// End of function createStake

    //Start of function removeStake
    // _stake holds the value of stake to be removed. 
    function removeStake(uint256 _stake) public
    {
        //The below LOC amends the cureent balance of the staked amount by substracting the staked amount from the given address from stakes[msg.sender].
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        // If the stake is zero, we remove the stakeholder using the address passed in as an argument using msg.sender.
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }// End of removeStake function.
    //Start of function stakeOf.
    // This function is used to keep track of the stakeholders and their investments.
    // This function takes in the value of stakeholder to find the staked amount of the user. 
    function stakeOf(address _stakeholder) public view returns(uint256)
    {
        // The function returns the amount staked with respect to stakeholders. 
        return stakes[_stakeholder];
    }// End of function stakeOf.
    // Start of function totalStakes. 
    //This function is used to find the aggregated stakes from all the stakeholders.
    function totalStakes() public view returns(uint256)
    {   //Initialising the variable totalStakes as a 0
        uint256 _totalStakes = 0;
        //Start of for loop
        //Initialising a for loop to count the sum of the staked amount
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
        }// End of for loop
        return _totalStakes;
    }// End of totalStakes().
    // Start of function isStakeholder
    // This function is used to check/know if the user is a stakeholder. 
    function isStakeholder(address _address) public view returns(bool, uint256)
    {// Start if for loop to iterate through the list of stakeholder addresses. 
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            // Start iof if clause. 
            // IF clause is used to check if the address is present in the list of the stakeholders which returns true of present. 
            if (_address == stakeholders[s]) return (true, s);
        }// End of for loop
        return (false, 0);
    } // End of isStakeholder function. 
    




 

}
