pragma solidity >=0.4.25 <0.7.0;
// import 
contract RandomNum {
    address owner;
    constructor()public{
        owner = msg.sender;
    }
    mapping(address=>uint256) winners;
    address[5] participants;
    uint8 randNonce=0;
    uint8 index = 0;
    address lastWinner;
    uint256 reward=0;
    //下注，每个玩家每轮只能下注一次，每次下注至少0.1ether，每轮参与人数不超过5个
    function bet()public payable{
        require(msg.value>=0.1 ether,"at least 0.1 ether");
        require(isNotPlayer(),"one person only one bet");
        reward = reward + msg.value;
        participants[index] = msg.sender;
        index++;
        if (index == 5){
            selectWiner();
        }
    }

    function isNotPlayer()private view returns(bool){
        for (uint8 i = 0;i < participants.length;i++){
            if (msg.sender == participants[i]){
                return false;
            }
        }
        return true;
    }

    function getReward()public view returns (uint256){
        return reward;
    }

    function getLastWinner()public view returns (address){
        return lastWinner;
    }
    event Transfer(address indexed winner,uint256);
    //根据随机数随机抽取一个，向该用户转发本轮彩票总额
    function selectWiner()private {
        require(index == 5, "Waiting for more users");
        address winner = participants[randomNumber()];
        winners[winner] += reward;
        // uint balance = address(this).balance;
        // address(uint160(winner)).transfer(address(this).balance);
        delete participants;
        index = 0;
        reward = 0;
        lastWinner = winner;
    }

    function randomNumber() private returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 5;
        randNonce++;
        return rand;
    }

    function withdrawal()public {
        uint256 r = winners[msg.sender];
        if (r == 0){
            return;
        }
        msg.sender.transfer(r);
        emit Transfer(msg.sender,r);
        delete winners[msg.sender];
        
    }

}