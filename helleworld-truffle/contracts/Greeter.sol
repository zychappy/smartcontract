pragma solidity >=0.4.25 <0.7.0;

contract Greeter         
{
    address creator;     
    string greeting;     

    constructor(string memory _greeting) public   
    {
        creator = msg.sender;
        greeting = _greeting;
    }
    

    function greet() public view returns (string memory)           
    {
        return greeting;
    }
    
    function setGreeting(string memory _newgreeting) public
    {
        greeting = _newgreeting;
    }

}