//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IXNXboxDrumpad.h"

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)testAllConnectedHID
{
    NSMutableArray *HIDs = [NSMutableArray new];
    struct hid_device_info *device_info, *devices;
    devices = hid_enumerate(0x0, 0x0);
    
    device_info = devices;
    while (device_info) {
        GameDevice *gameDevice = [GameDevice createWithHIDInfo:device_info];
        [HIDs addObject:gameDevice];
        
        device_info = device_info->next;
    }
    hid_free_enumeration(devices);
    
    NSLog(@"all connected HIDs : %@", HIDs);
    XCTAssertTrue([HIDs count] > 0, @"Connected HIDs should be more than one");
}

- (void)testConnectedGamepads
{
    NSArray *gamepads = [IXNXboxDrumpad connectedGamepads];
    
    XCTAssertTrue(gamepads.count > 0, @"The array of gamepads should not be empty (make sure you have connected at least one of xbox gamepad");
}

@end
