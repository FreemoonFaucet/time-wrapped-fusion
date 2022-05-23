// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;


interface IWFSN {
    error TransferETHFailed();

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    function deposit() external payable;
    function withdraw(uint256 amount) external;
}
