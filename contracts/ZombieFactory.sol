// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
  event NewZombie(uint zombieId, string name, uint dna);

  uint private dnaDigit = 16;
  uint private dnaModulus = 10 ** dnaDigit;

  struct Zombie {
    string name;
    uint dna;
  }

  Zombie[] public zombies;

  /**
   * @dev Creates a new zombie with the given name and DNA.
   * @param _name The name of the zombie.
   * @param _dna The DNA of the zombie.
   */
  function _createZombie(string memory _name, uint _dna) private {
    zombies.push(Zombie(_name, _dna));

    emit NewZombie(zombies.length - 1, _name, _dna);
  }

  /**
   * @dev Create a semi-random DNA from a given string
   * @param _str A string that will be hashed to create the DNA
   * @return The DNA of the zombie
   */
  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encode(_str)));

    return rand % dnaModulus;
  }

  /**
   * @dev Creates a new zombie with the given name.
   * @param _name The name of the zombie.
   */
  function createRandomZombie(string memory _name) public {
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }
}