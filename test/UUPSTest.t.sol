// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import { UUPSProxy } from "../src/UUPSProxy.sol";
import { ClockUUPS } from "../src/UUPSLogic/ClockUUPS.sol";
import { ClockUUPSV2 } from "../src/UUPSLogic/ClockUUPSV2.sol";
import { ClockUUPSV3 } from "../src/UUPSLogic/ClockUUPSV3.sol";

contract UUPSTest is Test {
  
  ClockUUPS public clock;
  ClockUUPSV2 public clockV2;
  UUPSProxy public uupsProxy;
  uint256 public alarm1Time;

  address admin;
  address user1;
  bytes private constructData;

  function setUp() public {
    admin = makeAddr("admin");
    user1 = makeAddr("noob");
    clock = new ClockUUPS();
    clockV2 = new ClockUUPSV2();
    vm.prank(admin);
    // initialize UUPS proxy
    uupsProxy = new UUPSProxy(abi.encodeWithSignature("setAlarm1(uint256)", 1234),address(clock));
  }

  function testProxyWorks() public {
    // check Clock functionality is successfully proxied
    vm.prank(admin);
    ClockUUPS ups = ClockUUPS(address(uupsProxy));
    assertEq(ups.alarm1(),1234);
    vm.stopPrank();
  }

  function testUpgradeToWorks() public {
    // check upgradeTo works aswell
    vm.prank(admin);
    ClockUUPS ups = ClockUUPS(address(uupsProxy));
    ups.upgradeTo(address(clockV2));
    ClockUUPSV2 upsV2 = ClockUUPSV2(address(uupsProxy));
    upsV2.setAlarm1(12345);
    assertEq(upsV2.alarm1(),12345);
    vm.stopPrank();
  }

  function testCantUpgrade() public {
    // check upgradeTo should fail if implementation doesn't inherit Proxiable
    vm.prank(admin);
    ClockUUPS ups = ClockUUPS(address(uupsProxy));
    ups.upgradeTo(address(clockV2));
    ClockUUPSV2 upsV2 = ClockUUPSV2(address(uupsProxy));
    //v2 doesn't inherit Proxiable so that the success status is false.
    (bool success, ) = address(upsV2).call(abi.encodeWithSignature("proxiableUUID()"));
    vm.stopPrank();
    assertEq(success, false);
  }
  
  function testCantUpgradeIfLogicDoesntHaveUpgradeFunction() public {
    // check upgradeTo should fail if implementation doesn't implement upgradeTo
    vm.prank(admin);
    ClockUUPSV3 clockV3 = new ClockUUPSV3();
    uupsProxy = new UUPSProxy(abi.encodeWithSignature("setAlarm1(uint256)", 1234),address(clockV3));
    ClockUUPSV3 upsV3 = ClockUUPSV3(address(uupsProxy));
    (bool proxiable, ) = address(upsV3).call(abi.encodeWithSignature("proxiableUUID()"));
    (bool upgradeTo, ) = address(upsV3).call(abi.encodeWithSignature("upgradeTo()"));
    vm.stopPrank();
    //the V3 contract inherit the Proxiable so the proxiable will be true.
    //but it doesn't implement upgrade function do upgradeTo will be false.
    assertEq(proxiable, true);
    assertEq(upgradeTo, false);
  }

}