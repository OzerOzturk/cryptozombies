// version of solidity
pragma solidity >=0.5.0 <0.6.0;

// added import statement 
import "./zombiefactory";

// For our contract to talk to another contract on the blockchain that we don't own, first we need to define an interface
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
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

//  it makes sense to split your code logic across multiple contracts to organize the code. (inheritance)
contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);
   
   
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    // making sure we own this zombie 
    require(msg.sender == zombieToOwner[_zombieId]);
    // Storage refers to variables stored permanently on the blockchain. Memory variables are temporary
    Zombie storage myZombie = zombies[_zombieId];  
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // call feedAndMultiply function
    feedAndMultiply(_zombieId, kittyDna, "kitty"); 
  }

}