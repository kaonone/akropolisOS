pragma solidity ^0.5.12;
/**
 * @dev Double linked list with address items
 */
library AddressList {

    address constant  ZERO_ADDRESS = address(0);

    struct Data {
        address head;
        address tail;
        uint    length;
        mapping(address => bool)    isContain;
        mapping(address => address) nextOf;
        mapping(address => address) prevOf;
    }

    /**
     * @dev Append element to end of list
     * @param _data is list storage ref
     * @param _item is a new list element
     */
    function append(Data storage _data, address _item) internal
    {
        append(_data, _item, _data.tail);
    }

    /**
     * @dev Append element to end of element
     * @param _data is list storage ref
     * @param _item is a new list element
     * @param _to is a item element before new
     * @notice gas usage < 100000
     */
    function append(Data storage _data, address _item, address _to) internal {
        // Unable to contain double element
        require(!_data.isContain[_item], "Unable to contain double element");

        // Empty list
        if (_data.head == ZERO_ADDRESS) {
            _data.head = _data.tail = _item;
        } else {
            require(_data.isContain[_to], "Append target not contained");

            address  nextTo = _data.nextOf[_to];
            if (nextTo != ZERO_ADDRESS) {
                _data.prevOf[nextTo] = _item;
            } else {
                _data.tail = _item;
            }

            _data.nextOf[_to] = _item;
            _data.prevOf[_item] = _to;
            _data.nextOf[_item] = nextTo;
        }
        _data.isContain[_item] = true;
        ++_data.length;
    }

    /**
     * @dev Prepend element to begin of list
     * @param _data is list storage ref
     * @param _item is a new list element
     */
    function prepend(Data storage _data, address _item) internal
    {
        prepend(_data, _item, _data.head);
    }

    /**
     * @dev Prepend element to element of list
     * @param _data is list storage ref
     * @param _item is a new list element
     * @param _to is a item element before new
     */
    function prepend(Data storage _data, address _item, address _to) internal {
        require(!_data.isContain[_item], "Unable to contain double element");

        // Empty list
        if (_data.head == ZERO_ADDRESS) {
            _data.head = _data.tail = _item;
        } else {
            require(_data.isContain[_to], "Preppend target is not contained");

            address  prevTo = _data.prevOf[_to];
            if (prevTo != ZERO_ADDRESS) {
                _data.nextOf[prevTo] = _item;
            } else {
                _data.head = _item;
            }

            _data.prevOf[_item] = prevTo;
            _data.nextOf[_item] = _to;
            _data.prevOf[_to] = _item;
        }
        _data.isContain[_item] = true;
        ++_data.length;
    }

    /**
     * @dev Remove element from list
     * @param _data is list storage ref
     * @param _item is a removed list element
     */
    function remove(Data storage _data, address _item) internal {
        require(_data.isContain[_item], "Item is not contained");

        address  elemPrev = _data.prevOf[_item];
        address  elemNext = _data.nextOf[_item];

        if (elemPrev != ZERO_ADDRESS) {
            _data.nextOf[elemPrev] = elemNext;
        } else {
            _data.head = elemNext;
        }

        if (elemNext != ZERO_ADDRESS) {
            _data.prevOf[elemNext] = elemPrev;
        } else {
            _data.tail = elemPrev;
        }

        _data.isContain[_item] = false;
        --_data.length;
    }

    /**
     * @dev Replace element on list
     * @param _data is list storage ref
     * @param _from is old element
     * @param _to is a new element
     */
    function replace(Data storage _data, address _from, address _to) internal {

        require(_data.isContain[_from], "Old element not contained");
        require(!_data.isContain[_to], "New element is already contained");

        address  elemPrev = _data.prevOf[_from];
        address  elemNext = _data.nextOf[_from];

        if (elemPrev != ZERO_ADDRESS) {
            _data.nextOf[elemPrev] = _to;
        } else {
            _data.head = _to;
        }

        if (elemNext != ZERO_ADDRESS) {
            _data.prevOf[elemNext] = _to;
        } else {
            _data.tail = _to;
        }

        _data.prevOf[_to] = elemPrev;
        _data.nextOf[_to] = elemNext;
        _data.isContain[_from] = false;
        _data.isContain[_to] = true;
    }

    /**
     * @dev Swap two elements of list
     * @param _data is list storage ref
     * @param _a is a first element
     * @param _b is a second element
     */
    function swap(Data storage _data, address _a, address _b) internal {
        require(_data.isContain[_a] && _data.isContain[_b], "Can not swap element which is not contained");

        address prevA = _data.prevOf[_a];

        remove(_data, _a);
        replace(_data, _b, _a);

        if (prevA == ZERO_ADDRESS) {
            prepend(_data, _b);
        } else if (prevA != _b) {
            append(_data, _b, prevA);
        } else {
            append(_data, _b, _a);
        }
    }

    function first(Data storage _data)  internal view returns (address)
    { 
        return _data.head; 
    }

    function last(Data storage _data)  internal view returns (address)
    { 
        return _data.tail; 
    }

    /**
     * @dev Chec list for element
     * @param _data is list storage ref
     * @param _item is an element
     * @return `true` when element in list
     */
    function contains(Data storage _data, address _item)  internal view returns (bool)
    { 
        return _data.isContain[_item]; 
    }

    /**
     * @dev Next element of list
     * @param _data is list storage ref
     * @param _item is current element of list
     * @return next elemen of list
     */
    function next(Data storage _data, address _item)  internal view returns (address)
    { 
        return _data.nextOf[_item]; 
    }

    /**
     * @dev Previous element of list
     * @param _data is list storage ref
     * @param _item is current element of list
     * @return previous element of list
     */
    function prev(Data storage _data, address _item) internal view returns (address)
    { 
        return _data.prevOf[_item]; 
    }
}