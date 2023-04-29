// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import { Slots } from "./SlotManipulate.sol";
import { BasicProxy } from "./BasicProxy.sol";

contract Transparent is Slots, BasicProxy {

  bytes32 constant private CONTRACT_SLOTADDRESS = bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1);
  bytes32 constant private ADMIN_SLOTADDRESS = bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1);
  constructor(address _implementation) BasicProxy(_implementation) {
    // TODO: set admin address to Admin slot
    _setSlotToAddress(CONTRACT_SLOTADDRESS, _implementation);
    _setSlotToAddress(ADMIN_SLOTADDRESS, msg.sender);
  }

  function getAdmin() private view returns (address){
    return _getSlotToAddress(ADMIN_SLOTADDRESS);
  }
  modifier onlyAdmin {
    // TODO: finish onlyAdmin modifier
    if (msg.sender == getAdmin()) {
      _;
    } else {
      _fallback();
    }
  }

  function _fallback() internal {
    _delegate(_getSlotToAddress(CONTRACT_SLOTADDRESS));
  }

  function upgradeTo(address _newImpl) public override onlyAdmin {
    // TODO: rewriet upgradeTo
    _setSlotToAddress(CONTRACT_SLOTADDRESS, _newImpl);
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public override onlyAdmin {
    _setSlotToAddress(CONTRACT_SLOTADDRESS, _newImpl);
    (bool success, ) = _newImpl.delegatecall(data);
    require(success);
  }

  fallback() external payable override {
    // rewrite fallback
    require(msg.sender != getAdmin());
    _delegate(_getSlotToAddress(CONTRACT_SLOTADDRESS));
  }
}