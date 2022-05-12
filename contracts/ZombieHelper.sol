// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
  modifier aboveLevel(uint256 _level, uint256 _zombieId) {
    require(zombies[_zombieId].level >= _level, "Zombie level too low");
    _;
  }

  function changeName(uint256 _zombieId, string calldata _newName)
    external
    aboveLevel(2, _zombieId)
  {
    require(
      zombieToOwner[_zombieId] == msg.sender,
      "You don't own this zombie"
    );

    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint256 _zombieId, uint256 _newDna)
    external
    aboveLevel(20, _zombieId)
  {
    require(
      zombieToOwner[_zombieId] == msg.sender,
      "You don't own this zombie"
    );

    zombies[_zombieId].dna = _newDna;
  }

  /**
   * @dev Returns all the ids of zombies owned by a user
   * (The id of a zombie is actually its position in the zombies array)
   * @param _owner The address of the user we want to look the zombies' up
   */
  function getZombiesByOwner(address _owner)
    external
    view
    returns (uint256[] memory)
  {
    uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
    uint256 counter = 0;

    for (uint256 i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }
}
