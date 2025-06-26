// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


//DAY 4 - TASK 2
/// @author Vivswaan Singh
/// @title VivswaansToken
contract VivswaansToken{
    // update the var name 
    uint256 private totalTokens;
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowanceMatrix;
    event Approval(address owner, address spender, uint amt);

    function totalNumberOfTokens() public view returns (uint256) {
        return totalTokens;
    }

    function balance(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 amount) public {
        require(amount <= balances[msg.sender],"Amount meant to be sent greater than that possessed by intended sender");
        require(to != address(0));

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function allowance(address owner,address spender) public view returns (uint256) {
        return allowanceMatrix[owner][spender];
    }

    function increaseAllowance(address spender,uint256 amt) public returns (bool){
        require(spender != address(0),"Invalid address");
        allowanceMatrix[msg.sender][spender]+=amt;
        emit Approval(msg.sender, spender, allowanceMatrix[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender,uint256 amt) public returns (bool) {
        require(spender != address(0),"Invalid address");
        require(amt<=allowanceMatrix[msg.sender][spender],"Amount meant to be decreased more than amount present");
        allowanceMatrix[msg.sender][spender]-=amt;
        emit Approval(msg.sender, spender, allowanceMatrix[msg.sender][spender]);
        return true;
    }

    function transferFrom(address from, address to, uint256 amt) public {
        // add check for allowance 
        require(to != address(0));

        balances[from] -= amt;
        balances[to] += amt;
    }

    function mintTokens(address account, uint256 amt) public {
        require(account != address(0),"Invalid Address");
        totalTokens += amt;
        balances[account] += amt;
    }

    function burnTokens(address account, uint256 amt) public {
        require(account != address(0),"Address Invalid");
        require(amt <= balances[account],"Amount meant to be deleted greater than that possessed");
        totalTokens -= amt;
        balances[account] -= amt;
    }
    function approve(address spender, uint256 amt) public returns (bool) {
        require(spender != address(0));

        allowanceMatrix[msg.sender][spender] = amt;
        emit Approval(msg.sender, spender, amt);
        return true;
    }
    
}