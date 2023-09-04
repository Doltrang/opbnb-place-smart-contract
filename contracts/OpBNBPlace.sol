// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721PausableUpgradeable.sol";

contract OpBNBPlace is AccessControlUpgradeable, PausableUpgradeable {
    // Consts
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");
    uint256 private constant DEFAULT_LOCK_TIME = 30;

    // Events
    event PlacePixel(address indexed _from, uint256 indexed _loc, uint256 _color, uint256 _lockUntil);

    // Storage
    address payable private _beneficary;
    uint256 private _placePrice;
    uint256 private _lockPriceEachSec;
    // @dev Pixel => LockTimeUntil in seconds
    mapping(uint256 => uint256) private _pixelLockTime;

    function initialize(address payable beneficary_) public initializer {
        __AccessControl_init_unchained();

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMIN_ROLE, _msgSender());
        _setupRole(WITHDRAWER_ROLE, _msgSender());

        _beneficary = beneficary_;
        _placePrice = 1000000000000000; // 0.001 bnb
        _lockPriceEachSec = 100000000000000; // 0.0001 bnb
    }

    // @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId) public view override(AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setBeneficary(address payable beneficary_) public onlyRole(ADMIN_ROLE) whenNotPaused {
        _beneficary = beneficary_;
    }

    function setPlacePrice(uint256 placePrice_) public onlyRole(ADMIN_ROLE) whenNotPaused {
        _placePrice = placePrice_;
    }

    function setLockPrice(uint256 lockPriceEachSec_) public onlyRole(ADMIN_ROLE) whenNotPaused {
        _lockPriceEachSec = lockPriceEachSec_;
    }

    /**
     * @dev called by the user to place a pixel
     * pixel data constructed as:
     * loc - Location of pixel = x*Dim + y
     * color - Color Code Index
     * lockSecs - Additional lock time for this pixel - By default lock time for every is 30secs
     */
    function placePixel(uint256 loc_, uint256 color_, uint256 lockSecs_) public payable whenNotPaused {
        require(_pixelLockTime[loc_] < block.timestamp, "Pixel Locked");
        require(msg.value >= _placePrice + _lockPriceEachSec * lockSecs_, "Invalid Amount");

        (bool isSuccess, ) = _beneficary.call{value: msg.value}("");
        require(isSuccess, "Transfer failed");

        uint256 lockUntilSec = block.timestamp + DEFAULT_LOCK_TIME + lockSecs_;
        _pixelLockTime[loc_] = lockUntilSec;

        // emit
        emit PlacePixel(_msgSender(), loc_, color_, lockUntilSec);
    }

    function withdrawAll() external virtual onlyRole(WITHDRAWER_ROLE) whenNotPaused {
        payable(_msgSender()).transfer(address(this).balance);
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() external virtual onlyRole(ADMIN_ROLE) whenNotPaused {
        _pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() external virtual onlyRole(ADMIN_ROLE) whenPaused {
        _unpause();
    }
}
