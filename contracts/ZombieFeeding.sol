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
  KittyInterface public kittyInterface;

  /**
   * @dev Sets the address of the CryptoKitties smart contract.
   * @param _address The new address to be set.
   */
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyInterface = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
    return _zombie.readyTime <= block.timestamp;
  }

  /**
   * @dev Allows a zombie to feed on a lifeform and multiply.
   * @param _zombieId The ID of the zombie to feed.
   * @param _targetDna The DNA of the target.
   * @param _species The species of the target.
   */
  function feedAndMultiply(
    uint256 _zombieId,
    uint256 _targetDna,
    string memory _species
  ) internal {
    require(
      zombieToOwner[_zombieId] == msg.sender,
      "You don't own this zombie"
    );
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie), "Zombie is not ready");

    _targetDna = _targetDna % dnaModulus;
    uint256 newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))) {
      newDna = newDna - (newDna % 100) + 99;
    }

    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  /**
   * @dev Allows a zombie to feed on a CryptoKitty.
   */
  function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
    uint256 kittyDna;

    (, , , , , , , , , kittyDna) = kittyInterface.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
