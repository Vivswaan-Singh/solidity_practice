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
    event Approval(address owner, address spender, uint amount);
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);
    error InvalidAddress(address addr);

    function totalNumberOfTokens() public view returns (uint256) {
        return totalTokens;
    }

    function balance(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 amount) public {
        if(to == address(0)){
            revert InvalidAddress({
                addr: to
            });
        }

        if(amount > balances[msg.sender]){
            revert InsufficientBalance({
                balance: balances[msg.sender],
                withdrawAmount: amount
            });
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function allowance(address owner,address spender) public view returns (uint256) {
        return allowanceMatrix[owner][spender];
    }

    function increaseAllowance(address spender,uint256 amount) public returns (bool){
        if(spender == address(0)){
            revert InvalidAddress({
                addr: spender
            });
        }

        allowanceMatrix[msg.sender][spender]+=amount;
        emit Approval(msg.sender, spender, allowanceMatrix[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender,uint256 amount) public returns (bool) {
        if(spender == address(0)){
            revert InvalidAddress({
                addr: spender
            });
        }
        if(amount > allowanceMatrix[msg.sender][spender]){
            revert InsufficientBalance({
                balance: allowanceMatrix[msg.sender][spender],
                withdrawAmount: amount
            });
        }
        allowanceMatrix[msg.sender][spender]-=amount;
        emit Approval(msg.sender, spender, allowanceMatrix[msg.sender][spender]);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public {
        // add check for allowance 
        if(to == address(0)){
            revert InvalidAddress({
                addr: to
            });
        }

        balances[from] -= amount;
        balances[to] += amount;
    }

    function mintTokens(address account, uint256 amount) public {
        if(account == address(0)){
            revert InvalidAddress({
                addr: account
            });
        }
        totalTokens += amount;
        balances[account] += amount;
    }

    function burnTokens(address account, uint256 amount) public {
        if(account == address(0)){
            revert InvalidAddress({
                addr: account
            });
        }

        if(amount > balances[account]){
            revert InsufficientBalance({
                balance: balances[account],
                withdrawAmount: amount
            });
        }
        totalTokens -= amount;
        balances[account] -= amount;
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        if(spender == address(0)){
            revert InvalidAddress({
                addr: spender
            });
        }

        allowanceMatrix[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
}