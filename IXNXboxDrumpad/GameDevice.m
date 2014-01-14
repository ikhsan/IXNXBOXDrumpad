//
//  GameDevice.m
//  Example
//
//  Created by Ikhsan Assaat on 1/14/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "GameDevice.h"
#import "hidapi.h"

@implementation GameDevice

- (instancetype)initWithHIDInfo:(struct hid_device_info *)info
{
    if (!(self = [super init])) return nil;
    
    _vendorId = info->vendor_id;
    _productId = info->product_id;
    
    const wchar_t *temp = info->manufacturer_string;
    _manufacturer = [[NSString alloc] initWithBytes:temp length:(sizeof(wchar_t) * wcslen(temp)) encoding:NSUTF32LittleEndianStringEncoding];
    
    temp = info->product_string;
    _product = [[NSString alloc] initWithBytes:temp length:(sizeof(wchar_t) * wcslen(temp)) encoding:NSUTF32LittleEndianStringEncoding];
    
    _usagePage = info->usage_page;
    _usage = info->usage;
    
    return self;
}

+ (instancetype)createWithHIDInfo:(struct hid_device_info *)info
{
    return [[GameDevice alloc] initWithHIDInfo:info];
}

- (NSString *)description
{
    if (self.manufacturer && ![self.manufacturer isEqualToString:@""])
        return [NSString stringWithFormat:@"%@'s %@", self.manufacturer, self.product];
    
    return self.product;
}


@end
