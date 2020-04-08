pragma solidity >=0.4.25 <0.7.0;
contract AddService{
    uint private _count;
    mapping(address=>bool) private _adders;
    function addByOne() public {
        //强制要求每个地址只能调用一次
        require(_adders[msg.sender] == false, "You have added already");
        //计数
        _count++;
        //调用账户的回调函数
        AdderInterface adder = AdderInterface(msg.sender);
        adder.notify();
        //将地址加入已调用集合
        _adders[msg.sender] = true;   
    }
    function getCount()public view returns(uint){
        return _count;
    }
}
contract AdderInterface{
    function notify() public;  
}