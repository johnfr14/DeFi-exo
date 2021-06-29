// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WrappedEther is ERC20 {
    using Address for address payable;

    event  Deposit(address indexed dst, uint256 amount);
    event  Withdrawal(address indexed src, uint256 amount);

    constructor() ERC20("Wrapped Ether", "WETH") {}

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wETH) public {
        _burn(msg.sender, wETH);
        payable(msg.sender).sendValue(wETH);
        emit  Withdrawal(msg.sender, wETH);
    }
}
