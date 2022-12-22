pragma solidity >=0.5.0 <0.6.0; //it's solidity version we use for the contract.

contract ZombieFactory {
    //we declare event here. event will let our frontend know every time a new zombie was create.
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16; // value of uint must be non-negative.
    uint256 dnaModulus = 10**dnaDigits;

    //struct is used for complext data type.
    struct Zombie {
        string name;
        uint256 dna;
    }

    //other contracts are able to read from but not write to.(public)
    Zombie[] public zombies;

    //there is a convention while creating functions, such as an underscore(_) usage. "memory" is used for specifying where _name variable is stored.
    //we mark our function "private" to prevent possible attacks. we only make it "public" to expose it to the world
    function _createZombie(string memory _name, uint256 _dna) private {
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1; //it indicates the zombie we just added. and store it in a uint256 called id.
        emit NewZombie(id, _name, _dna); //fire an event
    }

    //this function is only viewing the data but not modifying it
    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        //ethereum has the hash function keccak256 built in.
        //basically maps an input into a random 256-bit hexadecimal number.A slight change in the input will cause a large change in the hash.
        //generate a pseudo random hexadecimal
        //typecasting: convert between data types
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus; //make it 16 digits long
    }

    function createRandomZombie(string memory _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, _randDna);
    }
}
