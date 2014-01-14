//
//  IXNXboxDrumpad.m
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "IXNXboxDrumpad.h"

#import "hidapi.h"
#import <IOKit/hid/IOHIDUsageTables.h>
#import "GameDevice.h"

@interface IXNXboxDrumpad () {
    hid_device *_device;
}

@end


@implementation IXNXboxDrumpad

+ (NSArray *)connectedGamepads
{
    NSMutableArray *gamepads = [NSMutableArray new];
    struct hid_device_info *device_info, *devices;
    devices = hid_enumerate(0x0, 0x0);
    
    device_info = devices;
    while (device_info) {
        GameDevice *gameDevice = [GameDevice createWithHIDInfo:device_info];
        if (gameDevice.usagePage == kHIDPage_GenericDesktop && gameDevice.usage == kHIDUsage_GD_GamePad)
            [gamepads addObject:gameDevice];
        
        device_info = device_info->next;
    }
    hid_free_enumeration(devices);
    
    return gamepads;
}

- (instancetype)initWithDevice:(GameDevice *)device
{
    if (!(self = [super init])) return nil;
    
    _device = hid_open(device.vendorId, device.productId, NULL);
    
    return self;
}

+ (instancetype)drumpadWithDevice:(GameDevice *)device
{
    return [[IXNXboxDrumpad alloc] initWithDevice:device];
}

- (void)listen
{
    if (!_device) return;
    
    dispatch_queue_t q = dispatch_queue_create("me.ikhsan.xboxdrum", NULL);
    dispatch_async(q, ^{
        hid_set_nonblocking(_device, 1);
        
        int res;
        unsigned char buf[65];
        
        while (true) {
            res = hid_read(_device, buf, 65);
            
            if (res <= 0) continue;
            
            if (buf[1] == 20 && buf[3] == 64) {
                [self buttonEventIsFired:KeyEventPressedX];
                [self padEventIsFired:KeyEventHitBlue];
            }
            
            if (buf[1] == 20 && buf[3] == 128) {
                [self buttonEventIsFired:KeyEventPressedY];
                [self padEventIsFired:KeyEventHitYellow];
            }
            
            if (buf[1] == 20 && buf[3] == 16) {
                [self buttonEventIsFired:KeyEventPressedA];
                [self padEventIsFired:KeyEventHitGreen];
            }
            
            if (buf[1] == 20 && buf[3] == 32) {
                [self buttonEventIsFired:KeyEventPressedB];
                [self padEventIsFired:KeyEventHitRed];
            }
            
            if (buf[1] == 20 && buf[3] == 1) {
                [self padEventIsFired:KeyEventHitOrange];
            }
            
            if (buf[1] == 20 && buf[3] == 4) {
                [self buttonEventIsFired:KeyEventPressedXBOX];
            }
            
            if (buf[1] == 20 && buf[2] == 1) {
                [self buttonEventIsFired:KeyEventPressedArrowUp];
            }
            
            if (buf[1] == 20 && buf[2] == 8) {
                [self buttonEventIsFired:KeyEventPressedArrowRight];
            }
            
            if (buf[1] == 20 && buf[2] == 2) {
                [self buttonEventIsFired:KeyEventPressedArrowDown];
            }
            
            if (buf[1] == 20 && buf[2] == 4) {
                [self buttonEventIsFired:KeyEventPressedArrowLeft];
            }
            
            if (buf[1] == 20 && buf[2] == 0 && buf[3] == 0) {
                [self buttonEventIsFired:KeyEventReleased];
                [self padEventIsFired:KeyEventPadRelease];
            }
        }
        
    });
}

- (void)buttonEventIsFired:(KeyEventButton)buttonEvent
{
    if (!self.delegate) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate xboxDrumpad:self keyEventButton:buttonEvent];
    });
}

- (void)padEventIsFired:(KeyEventPad)padEvent
{
    if (!self.delegate) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate xboxDrumpad:self keyEventPad:padEvent];
    });
}

//
// More information about triggering LED event
// http://www.lastrayofhope.com/2009/06/26/athena-xbox-360-pad-and-mac-os-x-cont/#codesyntax_2
// http://tattiebogle.net/index.php/ProjectRoot/Xbox360Controller/UsbInfo#toc3
//

- (void)triggerLEDEvent:(LEDTrigger)trigger
{
    const unsigned char kReportType = 0x01;
	const unsigned char kReportSize = 0x03;
    const unsigned char kReportData[kReportSize] = {kReportType, kReportSize, trigger};
    
    hid_write(_device, kReportData, kReportSize);
}


@end
