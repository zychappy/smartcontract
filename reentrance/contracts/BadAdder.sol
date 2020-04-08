pragma solidity >=0.4.25 <0.7.0;
import "./AddService.sol";
contract BadAdder is AdderInterface{

    AddService private _addService;
    uint private _calls;

    function notify() public{
        if(_calls > 5){
            return;
        }
        _calls++;
        //Attention !!!!!!
        _addService.addByOne();
    }

    function setAddService(address _addr) public {
        _addService = AddService(_addr);
    }
    function doAdd() public{
        _addService.addByOne();    
    }
}