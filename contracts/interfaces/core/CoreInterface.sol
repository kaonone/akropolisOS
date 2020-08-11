pragma solidity ^0.5.12;

contract CoreInterface {

    /* Module manipulation events */

    event ModuleAdded(string name, address indexed module);

    event ModuleRemoved(string name, address indexed module);

    event ModuleReplaced(string name, address indexed from, address indexed to);


    /* Functions */

    function set(string memory  _name, address _module, bool _constant) public;

    function setMetadata(string memory _name, string  memory _description) public;

    function remove(string memory _name) public;
    
    function contains(address _module)  public view returns (bool);

    function size() public view returns (uint);

    function isConstant(string memory _name) public view returns (bool);

    function get(string memory _name)  public view returns (address);

    function getName(address _module)  public view returns (string memory);

    function first() public view returns (address);

    function next(address _current)  public view returns (address);
}