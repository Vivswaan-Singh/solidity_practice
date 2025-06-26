//DAY 4 - TASK 1
/// @author Vivswaan Singh
/// @title ContractA
contract ContractA{
    address public owner;

    constructor() payable {
        owner=msg.sender;
    }

    event Response(bool success, bytes data);

    function sendToB(address payable _addB,address payable _addC,uint _amt) external {
        require(msg.sender==owner,"Caller is not owner");
        require(_amt <= address(this).balance, "Insufficient balance");
        ContractB(_addB).forwardToC{value: _amt}(_addC);
    }

    function sendToD(address payable _addD) external payable {
        require(msg.value>0,"No ETH sent");
        require(msg.sender==owner,"Caller is not owner");
        (bool success,bytes memory data) = _addD.call{value: msg.value}("");
        emit Response(success, data);
        require(success,string(data));
    }

    function getETH() external view returns (uint256) {
       return address(this).balance;
    }

}

/// @author Vivswaan Singh
/// @title ContractB
contract ContractB{
    address public owner;

    constructor(){
        owner=msg.sender;
    }

    function forwardToC(address payable _addC) external payable {
        require(msg.value>0,"No ETH sent");
        (bool success,) = _addC.call{value: msg.value}("");
        require(success, "Failed to send Ether");
    }

    function getETH() external view returns (uint256) {
       return address(this).balance;
    }

}

/// @author Vivswaan Singh
/// @title ContractC
contract ContractC{
    address public owner;

    constructor(){
        owner=msg.sender;
    }

    receive() external payable {}

    function getETH() external view returns (uint256) {
       return address(this).balance;
    }

}

/// @author Vivswaan Singh
/// @title ContractD
contract ContractD{
    address public owner;

    constructor(){
        owner=msg.sender;
    }

    receive() external payable {
        revert("receive Rejected ETH");
    }

    function getETH() external view returns (uint256) {
       return  address(this).balance;
    }

}