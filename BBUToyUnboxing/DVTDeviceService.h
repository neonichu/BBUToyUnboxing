/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import <Foundation/Foundation.h>

@class DVTDevice, DVTDeviceCapability, DVTExtension;

@interface DVTDeviceService : NSObject

@property(readonly) DVTDeviceCapability *currentCapability;
@property(readonly) DVTDevice *device;

+ (id)capability;
- (id)initForDevice:(id)arg1 extension:(id)arg2 capability:(id)arg3;

@end

