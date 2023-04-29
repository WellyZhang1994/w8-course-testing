// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import { SlotManipulate } from "../src/SlotManipulate.sol";

contract SlotManipulateTest is Test {

  using stdStorage for StdStorage;
  address randomAddress;
  SlotManipulate instance;

  function setUp() public {
    instance = new SlotManipulate();
    randomAddress = makeAddr("jack");
  }

  function bytes32ToAddress(bytes32 _bytes32) internal pure returns (address) {
    return address(uint160(uint256(_bytes32)));
  }

  function testValueSet() public {
    // TODO: set bytes32(keccak256("appwork.week8"))

    // Assert that the value is set 
    vm.startPrank(randomAddress);
    instance.setAppworksWeek8(2023_4_27);
    assertEq(
      uint256(vm.load(address(instance), keccak256("appworks.week8"))),
      2023_4_27
    );
    vm.stopPrank();
  }

  function testSetProxyImplementation() public {
    // TODO: set Proxy Implementation address
    // Assert that the value is set
    vm.startPrank(randomAddress);
    instance.setProxyImplementation(address(randomAddress));
    assertEq(
      bytes32ToAddress(vm.load(address(instance), bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1))),
      address(randomAddress)
    );
    vm.stopPrank();
  }

  function testSetBeaconImplementation() public {
    // TODO: set Beacon Implementation address
    // Assert that the value is set 
    vm.startPrank(randomAddress);
    instance.setBeaconImplementation(address(randomAddress));
    assertEq(
      bytes32ToAddress(vm.load(address(instance), bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1))),
      address(randomAddress)
    );
    vm.stopPrank();
  }

  function testSetAdminImplementation() public {
    // TODO: set admin address
    // Assert that the value is set 
    vm.startPrank(randomAddress);
    instance.setAdminImplementation(address(randomAddress));
    assertEq(
      bytes32ToAddress(vm.load(address(instance), bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1))),
      address(randomAddress)
    );
    vm.stopPrank();
  }

  function testSetProxiableImplementation() public {
    // TODO: set Proxiable address
    // Assert that the value is set 
    vm.startPrank(randomAddress);
    instance.setProxiable(address(randomAddress));
    assertEq(
      bytes32ToAddress(vm.load(address(instance), keccak256("PROXIABLE"))),
      address(randomAddress)
    );
    vm.stopPrank();
  }

}