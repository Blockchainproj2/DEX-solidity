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

     // Function to execute a trade
    function trade(bytes32 ticker, uint256 amount, uint256 maxPrice) external {
        Pair storage pair = pairs[ticker];
        require(address(pair.token) != address(0), "Pair does not exist");

        uint256 totalPrice = amount * pair.price;
        require(totalPrice <= maxPrice, "Trade exceeds maximum price");

        // Transfer tokens from the buyer to the DEX
        pair.token.transferFrom(msg.sender, address(this), amount);

        // Transfer tokens from the DEX to the buyer
        pair.token.transfer(msg.sender, amount);

        // Emit trade execution event
        emit TradeExecuted(msg.sender, address(this), ticker, amount, pair.price);
    }

     // Function to update the price of a trading pair
    function updatePrice(bytes32 ticker, uint256 newPrice) external {
        Pair storage pair = pairs[ticker];
        require(address(pair.token) != address(0), "Pair does not exist");

        pair.price = newPrice;
    }


   }
