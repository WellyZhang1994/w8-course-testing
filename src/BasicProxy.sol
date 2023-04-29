// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import { Proxy } from "./Proxy/Proxy.sol";
import { Slots } from "./SlotManipulate.sol";

contract BasicProxy is Proxy, Slots {

  bytes32 constant private SLOTADDRESS = bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1);
  constructor(address _implementation) {
     _setSlotToAddress(SLOTADDRESS, _implementation);
  }

  fallback() external payable virtual {
    _delegate(_getSlotToAddress(SLOTADDRESS));
  }

  receive() external payable {}

  function upgradeTo(address _newImpl) public virtual {
    _setSlotToAddress(SLOTADDRESS, _newImpl);
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public virtual {
    _setSlotToAddress(SLOTADDRESS, _newImpl);
    (bool success, ) = _newImpl.delegatecall(data);
    require(success);
  }
}