// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
/// @title Quantex Coin (QTX), The native exchange token for the Quantex Exchange
/// @author Andrew N. Elkhoury
/// @notice The purpose of QTX is to act as a utility token on the Quantex Exchange
/// @dev After several tests, all function calls are currently implemented without side effects
/// @dev This contract follows roles based access control procedures. There is a separate role + admin for each privileged action
/// @custom:security-contact admin@myquantex.com
import "@openzeppelin/contracts@4.4.1/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts@4.4.1/access/AccessControl.sol";
import "@openzeppelin/contracts@4.4.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts@4.4.1/token/ERC20/extensions/ERC20Votes.sol";
contract QuantexCoin is ERC20, ERC20Snapshot, AccessControl, Pausable, ERC20Permit, ERC20Votes {
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant SNAPSHOT_ADMIN = keccak256("SNAPSHOT_ADMIN");
    bytes32 public constant PAUSER_ADMIN = keccak256("PAUSER_ADMIN");
    bytes32 public constant BURNER_ADMIN = keccak256("BURNER_ADMIN");
    constructor() ERC20("Quantex Coin", "QTX") ERC20Permit("Quantex Coin") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(SNAPSHOT_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(SNAPSHOT_ADMIN, msg.sender);
        _grantRole(PAUSER_ADMIN, msg.sender);
        _grantRole(BURNER_ADMIN, msg.sender);
        _mint(msg.sender, 300000000 * 10 ** decimals());
        _setRoleAdmin(SNAPSHOT_ROLE, SNAPSHOT_ADMIN);   
        _setRoleAdmin(PAUSER_ROLE, PAUSER_ADMIN);
        _setRoleAdmin(BURNER_ROLE, BURNER_ADMIN);
    }
    function burn(uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(_msgSender(), amount);
    }
    function snapshot() public onlyRole(SNAPSHOT_ROLE) {
        _snapshot();
    }
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
    // The following functions are overrides required by Solidity.
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }
    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }
    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
