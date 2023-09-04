// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract OpBNBPlace is AccessControlUpgradeable {
    /*** DATA TYPES ***/

    function initialize() public initializer {
        __AccessControl_init_unchained();
    }

    // @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view override(AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
