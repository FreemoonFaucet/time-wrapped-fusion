// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/WFSN.sol";


contract TestUser {
    function deposit(address wfsn, uint256 amount) external {
        IWFSN(wfsn).deposit{value: amount}();
    }

    function withdraw(address wfsn, uint256 amount) external {
        IWFSN(wfsn).withdraw(amount);
    }

    function transferFromToken(address token, address from, address to, uint256 amount) external {
        IWFSN(token).transferFrom(from, to, amount);
    }

    function transferFromData(address token, address from, address to, uint256 amount, bytes calldata data) external {
        IWFSN(token).transferFromData(from, to, amount, data);
    }

    function transferToken(address token, address to, uint256 amount) external {
        IWFSN(token).transfer(to, amount);
    }

    function transferData(address token, address to, uint256 amount, bytes calldata data) external {
        IWFSN(token).transferData(to, amount, data);
    }

    function approve(address token, address spender, uint256 amount) external {
        ISlice(token).approve(spender, amount);
    }

    function transferFSN(address to, uint256 amount) external returns (bool) {
        (bool success, ) = to.call{value:amount}(new bytes(0));
        return success;
    }

    receive() external payable {}
}

contract TestWFSN is Test {
    WFSN wfsn;
    TestUser testUserA;
    TestUser testUserB;
    TestUser testUserC;
    address terms = 0xABCDabcdABcDabcDaBCDAbcdABcdAbCdABcDABCd;


    // **** SET UP ****
    function setUp() public {
        wfsn = new WFSN(msg.sender, terms);
        testUserA = new TestUser();
        testUserB = new TestUser();
        testUserC = new TestUser();

        payable(address(testUserA)).transfer(100 ether);
        payable(address(testUserB)).transfer(100 ether);
        payable(address(testUserC)).transfer(100 ether);
    }

    function assertSupply(uint256 expected) public {
        uint256 supply = wfsn.totalSupply();
        assertEq(supply, expected);
    }

    function assertFSNBalance(address account, uint256 expected) public {
        uint256 balance = account.balance;
        assertEq(balance, expected);
    }

    function assertWrappedBalance(address account, uint256 expected) public {
        uint256 wrappedBalance = wfsn.balanceOf(account);
        assertEq(wrappedBalance, expected);
    }


    // **** TESTS ****
    function testDeposit() public {
        assertFSNBalance(address(testUserA), 100 ether);
        assertWrappedBalance(address(testUserA), 0);

        testUserA.deposit(address(wfsn), 10 ether);

        assertFSNBalance(address(testUserA), 90 ether);
        assertWrappedBalance(address(testUserA), 10 ether);
    }

    function testReceiveDeposit() public {
        bool success = testUserA.transferFSN(address(wfsn), 10 ether);
        if (!success) revert IWFSN.TransferETHFailed();

        assertFSNBalance(address(testUserA), 90 ether);
        assertWrappedBalance(address(testUserA), 10 ether);
    }

    function testWithdraw() public {
        testUserA.deposit(address(wfsn), 10 ether);

        testUserA.withdraw(address(wfsn), 5 ether);

        assertFSNBalance(address(testUserA), 95 ether);
        assertWrappedBalance(address(testUserA), 5 ether);
    }

    function testTransferFromWithdraw() public {
        testUserA.deposit(address(wfsn), 7 ether);

        assertFSNBalance(address(testUserA), 93 ether);
        assertWrappedBalance(address(testUserA), 7 ether);

        testUserA.approve(address(wfsn), address(testUserB), 7 ether);

        testUserB.transferFromToken(address(wfsn), address(testUserA), address(wfsn), 4 ether);

        assertFSNBalance(address(testUserA), 97 ether);
        assertWrappedBalance(address(testUserA), 3 ether);

        testUserB.transferFromToken(address(wfsn), address(testUserA), address(0), 3 ether);

        assertFSNBalance(address(testUserA), 100 ether);
        assertWrappedBalance(address(testUserA), 0);
    }

    function testTransferFromDataWithdraw() public {
        bytes memory data = abi.encodePacked("time wrapped fusion");

        testUserA.deposit(address(wfsn), 9 ether);

        assertFSNBalance(address(testUserA), 91 ether);
        assertWrappedBalance(address(testUserA), 9 ether);

        testUserA.approve(address(wfsn), address(testUserB), 9 ether);

        testUserB.transferFromData(address(wfsn), address(testUserA), address(wfsn), 8 ether, data);

        assertFSNBalance(address(testUserA), 99 ether);
        assertWrappedBalance(address(testUserA), 1 ether);

        testUserB.transferFromData(address(wfsn), address(testUserA), address(0), 1 ether, data);

        assertFSNBalance(address(testUserA), 100 ether);
        assertWrappedBalance(address(testUserA), 0);
    }

    function testTransferWithdraw() public {
        testUserA.deposit(address(wfsn), 5 ether);

        assertFSNBalance(address(testUserA), 95 ether);
        assertWrappedBalance(address(testUserA), 5 ether);

        testUserA.transferToken(address(wfsn), address(wfsn), 2 ether);

        assertFSNBalance(address(testUserA), 97 ether);
        assertWrappedBalance(address(testUserA), 3 ether);

        testUserA.transferToken(address(wfsn), address(0), 3 ether);

        assertFSNBalance(address(testUserA), 100 ether);
        assertWrappedBalance(address(testUserA), 0);
    }

    function testTransferDataWithdraw() public {
        bytes memory data = abi.encodePacked("time wrapped fusion");

        testUserA.deposit(address(wfsn), 2 ether);

        assertFSNBalance(address(testUserA), 98 ether);
        assertWrappedBalance(address(testUserA), 2 ether);

        testUserA.transferData(address(wfsn), address(wfsn), 1 ether, data);

        assertFSNBalance(address(testUserA), 99 ether);
        assertWrappedBalance(address(testUserA), 1 ether);

        testUserA.transferData(address(wfsn), address(0), 1 ether, data);

        assertFSNBalance(address(testUserA), 100 ether);
        assertWrappedBalance(address(testUserA), 0);
    }

    function testTransfer() public {
        testUserA.deposit(address(wfsn), 50 ether);

        assertFSNBalance(address(testUserA), 50 ether);
        assertWrappedBalance(address(testUserA), 50 ether);
        assertFSNBalance(address(testUserB), 100 ether);
        assertWrappedBalance(address(testUserB), 0);

        testUserA.transferToken(address(wfsn), address(testUserB), 23 ether);

        assertFSNBalance(address(testUserA), 50 ether);
        assertWrappedBalance(address(testUserA), 27 ether);
        assertFSNBalance(address(testUserB), 100 ether);
        assertWrappedBalance(address(testUserB), 23 ether);

        testUserB.withdraw(address(wfsn), 23 ether);

        assertFSNBalance(address(testUserB), 123 ether);
        assertWrappedBalance(address(testUserB), 0);
    }

    function testTransferFrom() public {
        testUserA.deposit(address(wfsn), 50 ether);

        assertFSNBalance(address(testUserA), 50 ether);
        assertWrappedBalance(address(testUserA), 50 ether);
        assertFSNBalance(address(testUserB), 100 ether);
        assertWrappedBalance(address(testUserB), 0);

        testUserA.approve(address(wfsn), address(testUserB), 19 ether);
        
        testUserB.transferFromToken(address(wfsn), address(testUserA), address(testUserC), 19 ether);

        assertWrappedBalance(address(testUserA), 31 ether);
        assertWrappedBalance(address(testUserB), 0);
        assertWrappedBalance(address(testUserC), 19 ether);
        
        testUserC.withdraw(address(wfsn), 19 ether);

        assertFSNBalance(address(testUserC), 119 ether);
        assertWrappedBalance(address(testUserC), 0);
    }

    function testInvalidAllowance() public {
        testUserA.deposit(address(wfsn), 100 ether);

        testUserA.approve(address(wfsn), address(testUserB), 99 ether);

        vm.expectRevert("FRC759: too less allowance");

        testUserB.transferFromToken(address(wfsn), address(testUserA), address(testUserC), 100 ether);
    }

    function testInvalidAllowanceData() public {
        bytes memory data = abi.encodePacked("time wrapped fusion");

        testUserA.deposit(address(wfsn), 100 ether);

        testUserA.approve(address(wfsn), address(testUserB), 99 ether);

        vm.expectRevert("FRC759: too less allowance");

        testUserB.transferFromData(address(wfsn), address(testUserA), address(testUserC), 100 ether, data);
    }
}
