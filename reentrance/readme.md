#### 0 环境准备
- Truffle v5.1.18 (core: 5.1.18)
- Solidity v0.5.16 (solc-js)
- Node v12.12.0
- Web3.js v1.2.1
- Ganache CLI v6.4.2 (ganache-core: 2.5.4)
#### 1 编译与部署
参见代码
#### 2 测试
部署好合约后，在调用badservice.doAdd()之前，需要先初始化addservice合约，
setAddService。  

执行doAdd()，结果变成了 7，就是回调函数执行了6次。
```
let a = await AddService.deployed()

truffle(development)> a.getCount()
BN { negative: 0, words: [ 0, <1 empty item> ], length: 1, red: null }
truffle(development)> let b = await BadAdder.deployed()

truffle(development)> b.setAddService('0x789B610edcA2b233f9f140d26ad98fD4C0a906a6')
{
  tx: '0xb88e0ba1f0f3b83a8a6000a25ba8420d2d295d80c707aed69bc002c8baa4cba5',
  receipt: {
    transactionHash: '0xb88e0ba1f0f3b83a8a6000a25ba8420d2d295d80c707aed69bc002c8baa4cba5',
    transactionIndex: 0,
    blockHash: '0xd388b7e6c989e334ec58ead032dbe6067ce9ba29447240d36c322593f85d33b5',
    blockNumber: 16,
    from: '0x07480ad219b2f34552d29143f5359b7f99e318c2',
    to: '0x7ec2960208e6f72b1c3b549ec2b819945891e99e',
    gasUsed: 43203,
    cumulativeGasUsed: 43203,
    contractAddress: null,
    logs: [],
    status: true,
    logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
    v: '0x1c',
    r: '0xd38779f3f40892c85de4b277efadad68f3231aafe115e28cbeb3833209bc399e',
    s: '0x397fdf7397b31456a3382660d50dcd94cb5ad0f311d25cf889bd2051dbaddf91',
    rawLogs: []
  },
  logs: []
}
truffle(development)> b.doAdd()
{
  tx: '0xb7a3526e22d5ef1bbf69b3a4a2c52cb16429ffc768d87c1a594829dec5ef64f7',
  receipt: {
    transactionHash: '0xb7a3526e22d5ef1bbf69b3a4a2c52cb16429ffc768d87c1a594829dec5ef64f7',
    transactionIndex: 0,
    blockHash: '0xe74f413db91924bae02a797b3fe69cf11fb84dd9715f84466dd32351060e03cc',
    blockNumber: 17,
    from: '0x07480ad219b2f34552d29143f5359b7f99e318c2',
    to: '0x7ec2960208e6f72b1c3b549ec2b819945891e99e',
    gasUsed: 201230,
    cumulativeGasUsed: 201230,
    contractAddress: null,
    logs: [],
    status: true,
    logsBloom: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',
    v: '0x1c',
    r: '0x896c012b2eddecb611274b4fac9fc89cccd7bf7d60d117021d95ef04f393c7b9',
    s: '0x7218e44c633834cad414ee7c9a3827233a5364141790c151cc1fc902014e4ce7',
    rawLogs: []
  },
  logs: []
}
truffle(development)> a.getCount()
BN { negative: 0, words: [ 7, <1 empty item> ], length: 1, red: null }
```
#### 3 解决方案
使用Checks-Effects-Interaction设计模式来组织代码。
  
Checks：参数验证  
Effects：修改合约状态  
Interaction：外部交互  
在进行外部调用之前，Checks-Effects已完成合约自身状态所有相关工作，使得状态完整、逻辑自洽，这样外部调用就无法利用不完整的状态进行攻击了。
```
//Checks
    require(_adders[msg.sender] == false, "You have added already");
    //Effects    
    _count++;
    //Interaction    
    AdderInterface adder = AdderInterface(msg.sender);
    adder.notify();
    //Effects
    _adders[msg.sender] = true;
```