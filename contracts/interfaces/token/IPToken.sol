pragma solidity ^0.5.12;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";

/**
 * @title PToken Interface
 */
interface IPToken {
    /* solhint-disable func-order */
    //Standart ERC20
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //Mintable & Burnable
    function mint(address account, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function burnFrom(address account, uint256 amount) external;

    //Distributions
    function distribute(uint256 amount) external;
    function claimDistributions(address account) external returns(uint256);
    function claimDistributions(address account, uint256 lastDistribution) external returns(uint256);
    function claimDistributions(address[] calldata accounts) external;
    function claimDistributions(address[] calldata accounts, uint256 toDistribution) external;
    function fullBalanceOf(address account) external view returns(uint256);
    function calculateDistributedAmount(uint256 startDistribution, uint256 nextDistribution, uint256 initialBalance) external view returns(uint256);
    function nextDistribution() external view returns(uint256);

}