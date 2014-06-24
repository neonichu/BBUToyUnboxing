//
//  BBUBBUToyUnboxing.m
//  BBUBBUToyUnboxing
//
//  Created by Boris Bügling on 24/06/14.
//    Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUBBUToyUnboxing.h"

static BBUBBUToyUnboxing *sharedPlugin;

@interface BBUBBUToyUnboxing()

@property (nonatomic, strong) NSBundle *bundle;

@end

#pragma mark -

@implementation BBUBBUToyUnboxing

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
