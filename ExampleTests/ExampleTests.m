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

- (void)testConnectedGamepads
{
    NSArray *gamepads = [IXNXboxDrumpad connectedGamepads];
    
    XCTAssertTrue(gamepads.count > 0, @"The array of gamepads should not be empty (make sure you have connected at least one of xbox gamepad");
}

@end
