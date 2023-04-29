// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import { Transparent } from "../src/Transparent.sol";
import { Clock } from "../src/Logic/Clock.sol";
import { ClockV2 } from "../src/Logic/ClockV2.sol";

contract TransparentTest is Test {
  
  Clock public clock;
  ClockV2 public clockV2;
  Transparent public transparentProxy;
  uint256 public alarm1Time;

  address admin;
  address user1;

  function setUp() public {
    admin = makeAddr("admin");
    user1 = makeAddr("noobUser");
    clock = new Clock();
    clockV2 = new ClockV2();
    vm.prank(admin);
    transparentProxy = new Transparent(address(clock));
    vm.stopPrank();
  }

  function testProxyWorks() public {
    // check Clock functionality is successfully proxied
    vm.startPrank(user1);
    Clock tempClock = Clock(address(transparentProxy));
    assertEq(tempClock.alarm1(),0);
  }

  function testUpgradeToOnlyAdmin(uint256 _alarm1, uint256 _alarm2) public {
    // check upgradeTo could be called only by admin
    vm.prank(admin);
    transparentProxy.upgradeTo(address(clockV2));
    ClockV2 tempClockV2 = ClockV2(address(transparentProxy));
    tempClockV2.setAlarm1(_alarm1);
    tempClockV2.setAlarm2(_alarm2);
    assertEq(tempClockV2.alarm1(),_alarm1);
    assertEq(tempClockV2.alarm2(),_alarm2);
  }

  function testUpgradeToAndCallOnlyAdmin(uint256 _alarm1, uint256 _alarm2) public {
    // check upgradeToAndCall could be called only by admin
    vm.prank(admin);
    transparentProxy.upgradeToAndCall(address(clockV2),abi.encodeWithSignature("setAlarm2(uint256)", _alarm2));
    ClockV2 tempClockV2 = ClockV2(address(transparentProxy));
    assertEq(tempClockV2.alarm2(),_alarm2);
  }

  function testFallbackShouldRevertIfSenderIsAdmin(uint256 _alarm1) public {
    // check admin shouldn't trigger fallback
    vm.prank(admin);
    transparentProxy.upgradeTo(address(clockV2));
    ClockV2 tempClockV2 = ClockV2(address(transparentProxy));
    tempClockV2.setAlarm1(_alarm1);
  }

  function testFallbackShouldSuccessIfSenderIsntAdmin(uint256 _alarm1) public {
    // check admin shouldn't trigger fallback
    vm.prank(admin);
    transparentProxy.upgradeTo(address(clockV2));
    ClockV2 tempClockV2 = ClockV2(address(transparentProxy));
    tempClockV2.setAlarm1(_alarm1);
  }
}