// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dex {
    // Structure to represent a trading pair
    struct Pair {
        IERC20 token;
        uint256 price; // Price in wei
    }

    // Mapping to store trading pairs
    mapping(bytes32 => Pair) public pairs;

    // Event to log trade executions
    event TradeExecuted(
        address indexed buyer,
        address indexed seller,
        bytes32 indexed ticker,
        uint256 amount,
        uint256 price
    );

    // Function to add a trading pair to the DEX
    function addPair(bytes32 ticker, address tokenAddress, uint256 initialPrice) external {
        require(initialPrice > 0, "Initial price must be greater than zero");
        require(address(pairs[ticker].token) == address(0), "Pair already exists");

        IERC20 token = IERC20(tokenAddress);
        pairs[ticker] = Pair(token, initialPrice);
    }

   }
