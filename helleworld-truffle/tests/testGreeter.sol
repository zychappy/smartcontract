pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "../contracts/Greeter.sol";

contract TestGreeter {
    function testGreet() public{
        string memory str = "helloword1";
        Greeter grt = new Greeter("helloword");
        Assert.equal(grt.greet(), str, "should say helloword");
    }
}