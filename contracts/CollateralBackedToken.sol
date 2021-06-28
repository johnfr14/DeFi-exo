// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./CollateralToken.sol";

contract CollateralBackedToken is ERC20, ERC20Burnable {
    using Address for address payable;

    CollateralToken private _collateral;

    event  Deposit(address indexed dst, uint256 amount);
    event  Withdrawal(address indexed src, uint256 amount);

    constructor(address collateralAddress) ERC20("CollateralBackedToken", "CBT") {
        _collateral = CollateralToken(collateralAddress);
    }

     receive() external payable {
        deposit(msg.value);
    }

    function deposit(uint256 amount) public {
        require(amount <= _collateral.balanceOf(msg.sender), "CollateralBackedToken: you don't have that amount of CT");
        _collateral.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount / 2);
        emit Deposit(msg.sender, amount / 2);
    }

    function withdraw(uint256 amount) public {
        require(amount <= balanceOf(msg.sender), "CollateralBackedToken: you don't have that amount of CBT");
        burnFrom(msg.sender, amount);
        _collateral.transfer(msg.sender, amount * 2);
        emit  Withdrawal(msg.sender, amount * 2);
    }
    
}
