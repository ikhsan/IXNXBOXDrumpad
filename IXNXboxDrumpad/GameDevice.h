//
//  GameDevice.h
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDevice : NSObject

@property (copy, nonatomic) NSString *manufacturer;
@property (copy, nonatomic) NSString *product;
@property (nonatomic) unsigned short vendorId;
@property (nonatomic) unsigned short productId;
@property (nonatomic) unsigned short usagePage;
@property (nonatomic) unsigned short usage;

+ (instancetype)createWithHIDInfo:(struct hid_device_info *)info;

@end
