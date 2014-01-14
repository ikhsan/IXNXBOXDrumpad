//
//  IXNXboxDrumpad.h
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KeyEventPressedArrowUp,
    KeyEventPressedArrowRight,
    KeyEventPressedArrowDown,
    KeyEventPressedArrowLeft,
    KeyEventPressedX,
    KeyEventPressedY,
    KeyEventPressedA,
    KeyEventPressedB,
    KeyEventPressedBack,
    KeyEventPressedXBOX,
    KeyEventPressedStart,
    KeyEventReleased = 99
} KeyEventButton;

typedef enum {
    KeyEventHitRed,
    KeyEventHitYellow,
    KeyEventHitBlue,
    KeyEventHitGreen,
    KeyEventHitOrange,
    KeyEventPadRelease = 99
} KeyEventPad;

typedef enum {
    LEDTriggerAllOff = 0x00,
    LEDTriggerAllBlink = 0x01,
    LEDTriggerFlashOn1 = 0x02,
    LEDTriggerFlashOn2 = 0x03,
    LEDTriggerFlashOn3 = 0x04,
    LEDTriggerFlashOn4 = 0x05,
    LEDTriggerOn1 = 0x06,
    LEDTriggerOn2 = 0x07,
    LEDTriggerOn3 = 0x08,
    LEDTriggerOn4 = 0x09,
    LEDTriggerRotating = 0x0a,
    LEDTriggerCurrentBlink = 0x0b,
    LEDTriggerSlowBlink = 0x0c,
    LEDTriggerAlternating = 0x0d
} LEDTrigger;

@class GameDevice;
@class IXNXboxDrumpad;

@protocol IXNXboxDrumpadDelegate <NSObject>

@optional
- (void)xboxDrumpad:(IXNXboxDrumpad *)drumpad keyEventButton:(KeyEventButton)buttonEvent;
- (void)xboxDrumpad:(IXNXboxDrumpad *)drumpad keyEventPad:(KeyEventPad)padEvent;

@end

@interface IXNXboxDrumpad : NSObject

@property (nonatomic, assign) id<IXNXboxDrumpadDelegate> delegate;

+ (NSArray *)connectedGamepads;
+ (instancetype)drumpadWithDevice:(GameDevice *)device;
- (void)listen;
- (void)triggerLEDEvent:(LEDTrigger)trigger;

@end
