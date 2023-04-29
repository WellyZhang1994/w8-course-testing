// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

contract Proxiable {

  bytes32 constant private SLOT = keccak256("PROXIABLE");

  function proxiableUUID() public pure returns (bytes32) {
    return 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
  }

  function _setSlotToAddress(bytes32 _slot, address value) internal {
    assembly {
      sstore(_slot, value)
    }
  }
  function updateCodeAddress(address newAddress) internal {
    // TODO: check if target address has proxiableUUID
    // update code address
    (bool success, bytes memory data)= newAddress.call(abi.encodeWithSignature("proxiableUUID()"));
    require(success);
    if(bytes32(data) == proxiableUUID()){
      _setSlotToAddress(SLOT ,newAddress);
    }
  }
}