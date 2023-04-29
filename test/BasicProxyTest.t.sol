// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { Clock } from "../src/Logic/Clock.sol";
import { ClockV2 } from "../src/Logic/ClockV2.sol";
import { BasicProxy } from "../src/BasicProxy.sol";

contract BasicProxyTest is Test {

  Clock public clock;
  ClockV2 public clockV2;
  BasicProxy public basicProxy;
  uint256 public alarm1Time;

  function setUp() public {
    clock = new Clock();
    clockV2 = new ClockV2();
    basicProxy = new BasicProxy(address(clock));
  }

  function testProxyWorks() public {
    // TODO: check Clock functionality is successfully proxied
    Clock tempClock = Clock(address(basicProxy));
    assertEq(tempClock.alarm1(),0);
  }

  function testInitialize() public {
    // TODO: check initialize works
    Clock tempClock = Clock(address(basicProxy));
    tempClock.initialize(1234);
    assertEq(tempClock.initialized(),true);
  }

  function testUpgrade() public {

    // TODO: check Clock functionality is successfully proxied
    // upgrade Logic contract to ClockV2
    // check state hadn't been changed
    // check new functionality is available
    basicProxy.upgradeTo(address(clockV2));
    ClockV2 tempClockV2 = ClockV2(address(basicProxy));
    tempClockV2.setAlarm2(1234);
    assertEq(tempClockV2.alarm2(),1234);
  }

  function testUpgradeAndCall() public {
    // TODO: calling initialize right after upgrade
    // check state had been changed according to initialize
    basicProxy.upgradeToAndCall(address(clockV2), abi.encodeWithSignature("setAlarm2(uint256)", 1234));
    ClockV2 tempClockV2 = ClockV2(address(basicProxy));
    assertEq(tempClockV2.alarm2(),1234);
  }

  function testChangeOwnerWontCollision() public {
    // TODO: call changeOwner to update owner
    // check Clock functionality is successfully proxied
    basicProxy.upgradeTo(address(clockV2));
    ClockV2 tempClockV2 = ClockV2(address(basicProxy));
    tempClockV2.changeOwner(address(this));
    assertEq(tempClockV2.alarm2(),0);
  }
}