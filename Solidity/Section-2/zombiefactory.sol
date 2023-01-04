// version of solidity
pragma solidity >=0.5.0 <0.6.0; 

// Create contract
contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    event NewZombie(uint zombieId, string name, uint dna);

    // Create zombies
    struct Zombie {
        string name;
        uint dna;
    }

    // Create an army array of zombies
    Zombie[] public zombies;

    //  one that keeps track of the address that owns a zombie, and another that keeps track of how many zombies an owner has.
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function createZombie (string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // assign ownership of the zombie to whoever called the function.
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }


    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str));
        return rand % dnaModulus; //our dna will only be 16 digits long
    }

    // randomly creating zombies 
    function createRandomZombie(string memory _name) public {
        // make sure this function only gets executed one time per user
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}