// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Contract.sol";

//Day 5
/// @author Vivswaan Singh
/// @title TestContract
contract TestContract is Test {
    VivswaansToken token;
    address addr1;
    address addr2;
    address addr3;
    address addr4;

    struct TestCase {
        uint256 init;
        uint256 rem;
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function setUp() public {
        token = new VivswaansToken();
        // addr1 = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp,"1")))));
        addr1 = address(1);
        addr2 = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp,"2")))));
        addr3 = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp,"1")))));
        addr4 = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp,"2")))));
        token.mintTokens(addr1,100);
        token.mintTokens(addr2,50);
        token.mintTokens(address(this),500);
    }

    function test_totalNumberOfTokens() public {
        assertEq(token.totalNumberOfTokens(),token.balance(addr1)+token.balance(addr2)+token.balance(address(this)),"totalNumberOfTokens failed");
    }

    function test_balance() public {
       assertEq(token.totalNumberOfTokens(),token.balance(addr1)+token.balance(addr2)+token.balance(address(this)),"totalNumberOfTokens failed");
    }

    function test_transfer(uint256 amt) public {
        uint256 bal1 = token.balance(address(this));
        uint256 bal2 = token.balance(addr2);

        vm.assume(amt < bal1 && amt > 0); 
        
        token.transfer(addr2,amt);
        uint256 newBal1=token.balance(address(this));
        uint256 newBal2=token.balance(addr2);

        if(bal1==newBal1 || bal2==newBal2 || bal1+bal2!=newBal1+newBal2){
            revert("transfer went wrong!!!");
        }
    }

    function test_transfer_addr(uint256 amt) public {
        vm.assume(amt>0 && amt<1024);
        address addr=address(0);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InvalidAddress.selector, addr)
        );
        token.transfer(addr,amt);
    }

    function test_transfer_insufficient(uint256 addon) public {
        uint256 bal1 = token.balance(address(this));
        vm.assume(addon>0 && addon<1024);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InsufficientBalance.selector, bal1, bal1+addon)
        );
        token.transfer(addr2,bal1+addon);
    }

    function test_allowance(uint256 amt) public {
        uint256 initAllowance=token.allowance(address(this),addr3);
        vm.assume(amt>0); 
        token.increaseAllowance(addr3,amt);
        assertEq(token.allowance(address(this),addr3),initAllowance+amt, "allowance failed");
    }

    function test_increaseAllowance(uint256 amt) public {
        vm.assume(amt>0); 
        uint256 intialBal=token.allowance(address(this),addr4);
        token.increaseAllowance(addr4,amt);
        assertEq(token.allowance(address(this),addr4),intialBal+amt, "increaseAllowance failed");
    }

    function test_increaseAllowance_addr(uint256 amt) public {
        vm.assume(amt>0 && amt<1024);
        address addr=address(0);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InvalidAddress.selector, addr)
        );
        token.increaseAllowance(addr,amt);
    }

    function fixtureAmts() public returns (TestCase[] memory) {
        TestCase[] memory entries = new TestCase[](6);
        entries[0] = TestCase(100, 20);
        entries[1] = TestCase(40, 5);
        entries[2] = TestCase(10, 2);
        entries[3] = TestCase(500, 50);
        entries[4] = TestCase(1024, 256);
        entries[5] = TestCase(5555, 55);
        return entries;
    }
    
    function table_test_decreaseAllowance(TestCase memory amts) public {
        token.increaseAllowance(addr3,amts.init);
        uint256 intialBal=token.allowance(address(this),addr3);
        token.decreaseAllowance(addr3,amts.rem);
        assertEq(token.allowance(address(this),addr3)+amts.rem,intialBal,"decreaseAllowance failed");
    }

    function test_decreaseAllowance_insufficient(uint256 init,uint256 addon) public {
        vm.assume(addon>0 && addon<1024 && init>0 && init<1024);
        token.increaseAllowance(addr3,init);
        uint256 intialBal=token.allowance(address(this),addr3);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InsufficientBalance.selector, intialBal, intialBal+addon)
        );
        token.decreaseAllowance(addr3,intialBal+addon);
    }

    function test_decreaseAllowance_addr(uint256 amt) public {
        vm.assume(amt>0 && amt<1024);
        address addr=address(0);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InvalidAddress.selector, addr)
        );
        token.decreaseAllowance(addr,amt);
    }

    function test_transferFrom(uint256 amt) public {
        uint256 bal1=token.balance(addr1);
        uint256 bal2=token.balance(addr2);
        vm.assume(amt>0 && amt<bal1);
        token.transferFrom(addr1,addr2,amt);
        uint256 newBal1=token.balance(addr1);
        uint256 newBal2=token.balance(addr2);
        if(bal1==newBal1 || bal2==newBal2 || bal1+bal2!=newBal1+newBal2){
            revert("transferFrom went wrong!!!");
        }
    }

    function test_burnTokens_insufficient(uint256 amt) public {
        uint256 bal=token.balance(addr1);
        vm.assume(amt<5*bal && amt>bal);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InsufficientBalance.selector, bal, amt)
        );
        token.burnTokens(addr1,amt);
    }

    function test_burnTokens_addr(uint256 amt) public {
        vm.assume(amt>0 && amt<1024);
        address addr=address(0);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InvalidAddress.selector, addr)
        );
        token.burnTokens(addr,amt);
    }

    function test_mintTokens(uint128 amt) public {
        vm.assume(amt>0 && amt<1024);
        uint256 bal=token.balance(addr1);
        token.mintTokens(addr1,amt);
        assertEq(bal+amt, token.balance(addr1), "mintTokens failed");
    }

    function test_mintTokens_addr(uint256 amt) public {
        vm.assume(amt>0 && amt<1024);
        address addr=address(0);
        vm.expectRevert(
            abi.encodeWithSelector(VivswaansToken.InvalidAddress.selector, addr)
        );
        token.mintTokens(addr,amt);
    }

}
