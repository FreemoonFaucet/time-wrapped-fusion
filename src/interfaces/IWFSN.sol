// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


interface IWFSN {
    error InsufficientAllowance();
    error Forbidden();
    error TransferETHFailed();

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    function deposit() external payable;
    function withdraw(uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transferFromData(address from, address to, uint256 amount, bytes calldata data) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferData(address to, uint256 amount, bytes calldata data) external returns (bool);

    function burn(address account, uint256 amount) external;
}