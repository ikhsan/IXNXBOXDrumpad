//
//  MainWindow.h
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSWindow

- (void)detectGamePads;
- (void)controlLED:(int)status;
- (void)showEvent:(int)eventType;

@end
