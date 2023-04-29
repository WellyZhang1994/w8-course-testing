// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import { UUPSProxy } from "../src/UUPSProxy.sol";
import { ClockUUPS } from "../src/UUPSLogic/ClockUUPS.sol";
import { ClockUUPSV2 } from "../src/UUPSLogic/ClockUUPSV2.sol";

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
    ups.setAlarm1(12345);
    assertEq(ups.alarm1(),12345);
    vm.stopPrank();
  }

  function testCantUpgrade() public {
    // check upgradeTo should fail if implementation doesn't inherit Proxiable

    // ans: I know the CloukUUPSV2 doesn't inherit Proxiable that I can't
    // call upgradeTo function to update the slot but...I don't know how to test it....
  }
  
  function testCantUpgradeIfLogicDoesntHaveUpgradeFunction() public {
    // check upgradeTo should fail if implementation doesn't implement upgradeTo
    // same as last test
  }

}