pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
    uint256 randNonce = 0;

    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;

        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        ownerOf(_zombieId)
    {
        Zombie storage myZombie = zombies[_zombieId];

        Zombie storage enemyZombie = zombies[_targetId];

        uint256 rand = randMod(100);

        //zombie victory situation
        if (rand <= attackVictoryProbability) {
            //we want to use the smallest uints we can get
            myZombie.winCount++;

            myZombie.level++;

            enemyZombie.lossCount++;

            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
            //zombie loss situation
        } else {
            myZombie.lossCount++;

            enemyZombie.winCount++;

            _triggerCooldown(myZombie);
        }
    }
}
