// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./zombieownership.sol";

contract CryptoZombies is ZombieOwnership {
    constructor() ERC721("Zombies", "ZMB") {}
}
