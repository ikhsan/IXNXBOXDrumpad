//
//  MainWindow.m
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "MainWindow.h"
#import "IXNXboxDrumpad.h"

@interface MainWindow () <IXNXboxDrumpadDelegate>

@property (weak) IBOutlet NSPopUpButton *deviceButtons;
@property (weak) IBOutlet NSTextField *messageField;
@property (weak) IBOutlet NSBox *LEDBox;

@property (strong, nonatomic) NSArray *connectedGamepads;
@property (strong) IXNXboxDrumpad *xboxpad;

- (IBAction)controlLED:(NSButton *)sender;

@end

@implementation MainWindow

- (NSArray *)connectedGamepads
{
    if (!_connectedGamepads)
        _connectedGamepads = [IXNXboxDrumpad connectedGamepads];
    
    return _connectedGamepads;
}

- (void)enableLEDBox:(BOOL)enable
{
    NSView *contentView = self.LEDBox.contentView;
    for (id obj in contentView.subviews) {
        if (![obj isKindOfClass:[NSButton class]]) continue;
        [(NSButton *)obj setEnabled:enable];
    }
}

- (void)detectGamePads
{
    if ([self.connectedGamepads count] == 0)
        [self displayMessage:@"Can't find any devices"];
    
    for (GameDevice *device in self.connectedGamepads) {
        NSString *deviceName = [NSString stringWithFormat:@"%@", device];
        [self.deviceButtons.menu addItemWithTitle:deviceName action:nil keyEquivalent:@""];
    }
    
    [self enableLEDBox:NO];
    int count = (int)self.deviceButtons.menu.numberOfItems;
    if (count > 1) {
        [self displayMessage:[NSString stringWithFormat:@"%d device are detected", count]];
    } else if (count == 1) {
        [self selectDevice:self.deviceButtons];
    }
}

- (IBAction)selectDevice:(NSPopUpButton *)sender
{
    GameDevice *device = self.connectedGamepads[sender.indexOfSelectedItem];
    IXNXboxDrumpad *pad = [IXNXboxDrumpad drumpadWithDevice:device];
    pad.delegate = self;
    [pad listen];
    
    self.xboxpad = pad;
    
    // enable LED Box
    [self enableLEDBox:YES];
    [self displayMessage:[NSString stringWithFormat:@"%@ is connected", device.product]];
}

- (void)displayMessage:(NSString *)message
{
    [self.messageField setStringValue:message];
}

- (IBAction)controlLED:(NSButton *)sender {
    if (!self.xboxpad) {
        [self displayMessage:@"There is no device connected"];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"LED is trigerring %@", [sender.title lowercaseString]];
    [self displayMessage:message];
    [self.xboxpad triggerLEDEvent:(LEDTrigger)sender.tag];
}

#pragma mark - Delegate methods

- (void)xboxDrumpad:(IXNXboxDrumpad *)drumpad keyEventButton:(KeyEventButton)buttonEvent
{
    NSArray *events = @[
        @"Up is pressed",
        @"Right is pressed",
        @"Down is pressed",
        @"Left is pressed",
        @"X is pressed",
        @"Y is pressed",
        @"A is pressed",
        @"B is pressed",
        @"Back is pressed",
        @"XBOX is pressed",
        @"Start is pressed",
        @"Button is released",
    ];
    
    if (buttonEvent < 12)
        [self displayMessage:events[buttonEvent]];
}

@end
