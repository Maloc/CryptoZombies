// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./zombieattack.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ZombieOwnership is ZombieAttack, ERC721 {
    mapping(uint256 => address) zombieApprovals;

    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 _balance)
    {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        public
        view
        override
        returns (address _owner)
    {
        return zombieToOwner[_tokenId];
    }

    function _transferOf(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerZombieCount[_to]++;
        ownerZombieCount[msg.sender]--;
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId)
        public
        onlyOwnerOf(_tokenId)
    {
        _transferOf(msg.sender, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(
            zombieToOwner[_tokenId] == msg.sender ||
                zombieApprovals[_tokenId] == msg.sender
        );

        _transferOf(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId)
        public
        override
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(zombieApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        _transferOf(owner, msg.sender, _tokenId);
    }
}
