pragma solidity ^0.5.12;

import "./AddressList.sol";

/**
 * @dev Iterable by index (string => address) mapping structure
 *      with reverse resolve and fast element remove
 */
library AddressMap {

    address constant  ZERO_ADDRESS = address(0);

    struct Data {
        mapping(bytes32 => address) valueOf;
        mapping(address => string)  keyOf;
        AddressList.Data            items;
    }

    using AddressList for AddressList.Data;

    /**
     * @dev Set element value for given key
     * @param _data is an map storage ref
     * @param _key is a item key
     * @param _value is a item value
     * @notice by design you can't set different keys with same value
     */
    function set(Data storage _data, string memory _key, address _value) internal {
        address replaced = get(_data, _key);
        if (replaced != ZERO_ADDRESS) {
            _data.items.replace(replaced, _value);
        } else {
            _data.items.append(_value);
        }
        _data.valueOf[keccak256(abi.encodePacked(_key))] = _value;
        _data.keyOf[_value] = _key;
    }

    /**
     * @dev Remove item from map by key
     * @param _data is an map storage ref
     * @param _key is and item key
     */
    function remove(Data storage _data, string memory _key) internal {
        address  value = get(_data, _key);
        _data.items.remove(value);
        _data.valueOf[keccak256(abi.encodePacked(_key))] = ZERO_ADDRESS;
        _data.keyOf[value] = "";
    }

    /**
     * @dev Get size of map
     * @return count of elements
     */
    function size(Data storage _data) internal view returns (uint)
    { return _data.items.length; }

    /**
     * @dev Get element by name
     * @param _data is an map storage ref
     * @param _key is a item key
     * @return item value
     */
    function get(Data storage _data, string memory _key) internal view returns (address)
    { return _data.valueOf[keccak256(abi.encodePacked(_key))]; }

    /** Get key of element
     * @param _data is an map storage ref
     * @param _item is a item
     * @return item key
     */
    function getKey(Data storage _data, address _item) internal view returns (string memory)
    { 
        return _data.keyOf[_item]; 
    }

}