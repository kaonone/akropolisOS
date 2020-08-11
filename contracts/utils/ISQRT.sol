pragma solidity ^0.5.12;

/**
 * @title Integer Square Root calculation for solidity
 */
library ISQRT {

    /**
     * @notice Calculate Square Root
     * @param n Operand of sqrt() function
     * @return greatest integer less than or equal to the square root of n
     */
    function sqrt(uint256 n) internal pure returns(uint256){
        return sqrtBabylonian(n);
    }

    /**
     * Based on Martin Guy implementation
     * http://freaknet.org/martin/tape/gos/misc/personal/msc/sqrt/sqrt.c
     */
    function isqrtBitByBit(uint256 x) internal pure returns (uint256){
        uint256 op = x;
        uint256 res = 0;
        /* "one" starts at the highest power of four <= than the argument. */
        uint256 one = 1 << 254; /* second-to-top bit set */
        while (one > op) {
            one = one >> 2;
        }
        while (one != 0) {
            if (op >= res + one) {
                op = op - (res + one);
                res = res + (one << 1);
            }
            res = res >> 1;
            one = one >> 2;
        }
        return res;
    }

    /**
     * Babylonian method implemented in dapp-bin library
     * https://github.com/ethereum/dapp-bin/pull/50
     */
    function sqrtBabylonian(uint256 x) internal pure returns (uint256) {
        // x == MAX_UINT256 makes this method fail, so in this case return value calculated separately
        if (x == 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) return 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2; //No overflow possible here, because greatest possible z = MAX_UINT256/2
        }
        return y;
    }
}