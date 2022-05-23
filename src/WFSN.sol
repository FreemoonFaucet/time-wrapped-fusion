// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "freemoon-frc759/FRC759.sol";

import "./interfaces/IWFSN.sol";


contract WFSN is FRC759, IWFSN {

    constructor() FRC759("Wrapped Fusion", "WFSN", 18, type(uint256).max) {}

    receive() external payable {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    function deposit() external payable {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        _burn(msg.sender, amount);

        _safeTransferETH(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);
    }

    function burn(address account, uint256 amount) external override {
        if (msg.sender != account) revert Forbidden();
        withdraw(amount);
    }

    function _safeTransferETH(address to, uint256 value) private {
        (bool success, ) = to.call{value: value}(new bytes(0));
        if (!success) revert TransferETHFailed();
    }
}
