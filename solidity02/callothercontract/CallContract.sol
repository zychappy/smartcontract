// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    uint256 private x = 0; // 状态变量x
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    // 返回合约ETH余额
    function getBalance() view public returns (uint) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 paramX) external payable {
        x = paramX;
        // 如果转入ETH，则释放Log事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns (uint paramX){
        paramX = x;
    }
}

contract CallContract {
    function callSetX(address targetAddress, uint256 x) external {
        OtherContract(targetAddress).setX(x);
    }

    function callGetX(OtherContract targetAddress) external view returns (uint x){
        x = targetAddress.getX();
    }

    function callGetX2(address targetAddress) external view returns (uint x){
        OtherContract oc = OtherContract(targetAddress);
        x = oc.getX();
    }

    function setXTransferETH(address targetContract, uint256 x) payable external {
        OtherContract(targetContract).setX{value: msg.value}(x);
    }
}