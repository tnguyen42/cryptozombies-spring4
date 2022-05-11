// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFactory.sol";

interface KittyInterface {
  function getKitty(uint256 _id)
    external
    view
    returns (
      bool isGestating,
      bool isReady,
      uint256 cooldownIndex,
      uint256 nextActionAt,
      uint256 siringWithId,
      uint256 birthTime,
      uint256 matronId,
      uint256 sireId,
      uint256 generation,
      uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
  address public ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface public kittyInterface = KittyInterface(ckAddress);

  function feedAndMultiply(
    uint256 _zombieId,
    uint256 _targetDna,
    string memory _species
  ) public {
    require(
      zombieToOwner[_zombieId] == msg.sender,
      "You don't own this zombie"
    );

    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))) {
      newDna = newDna - (newDna % 100) + 99;
    }

    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
    uint256 kittyDna;

    (, , , , , , , , , kittyDna) = kittyInterface.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
