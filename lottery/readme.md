#### 0 规则  
每次参与人数限定5人，参与者向合约发送0.1eth，满5人则进行抽奖，使用随机数得到获奖者，赢家通吃，抽奖完毕后，又可以进入下一轮。这里只为demo测试，规则没那么细。
#### 1 测试流程
1.1 经过编译，部署成功后，启用truffle console；
1.2 向合约发送eth,使用默认生成的前五个账号；
```
//先初始化一个实例
let r = await RandomNum.deployed()
r.bet({from:accounts[0],value:100000000000000000})
...
r.bet({from:accounts[4],value:100000000000000000})
```
1.3 查看获奖者
```
r.getLastWinner()
'0xDF3F6b7C21AAD62DAEf86Bd479907830B709189e'
//查看当前余额
web3.eth.getBalance("0xDF3F6b7C21AAD62DAEf86Bd479907830B709189e")
'99696694180000000000'
```
1.4 获取奖励
```
 r.withdrawal({from:"0xDF3F6b7C21AAD62DAEf86Bd479907830B709189e"})
```
再查看余额,多了大约0.5eth
```
 web3.eth.getBalance("0xDF3F6b7C21AAD62DAEf86Bd479907830B709189e")
'100196277820000000000'
```
#### 2 存在问题
在得出获奖者时，不能直接使用transfer，
```
// uint balance = address(this).balance;
        // address(uint160(winner)).transfer(address(this).balance);
```
会报异常，
```
Error: Returned error: VM Exception while processing transaction
```
所以不得不写一个提现的方法。
0.5版本的address 分为两种一种是普通的address，一种是address payable
官方文档解释

> The address type was split into address and address payable, 
where only address payable provides the transfer function. 
An address payable can be directly converted to an address, 
but the other way around is not allowed. 
Converting address to address payable is possible via conversion through uint160. 
If c is a contract, address(c) results in address payable only if c has a payable fallback function. 
If you use the withdraw pattern, you most likely do not have to change your code because transfer is only used on msg.sender instead of stored addresses and msg.sender is an address payable.
