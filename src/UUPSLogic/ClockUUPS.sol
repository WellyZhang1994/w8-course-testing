// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import { Slots } from "../SlotManipulate.sol";
import { Clock } from "../Logic/Clock.sol";
import { Proxiable } from "../Proxy/Proxiable.sol";

contract ClockUUPS is Clock, Proxiable {
  bytes32 constant private SLOT = keccak256("PROXIABLE");

  function upgradeTo(address _newImpl) public {
    // TODO: upgrade to new implementation
    _setSlotToAddress(SLOT, _newImpl);
  }

  function upgradeToAndCall(address _newImpl, bytes memory data) public {
    // TODO: upgrade to new implementation and call initialize
    _setSlotToAddress(SLOT, _newImpl);
    (bool success, ) = _newImpl.delegatecall(data);
    require(success);
  }
}