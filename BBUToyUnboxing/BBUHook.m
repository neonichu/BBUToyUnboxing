//
//  BBUHook.m
//  BBUToyUnboxing
//
//  Created by Boris Bügling on 01/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <objc/runtime.h>

#import "BBUHook.h"

@implementation BBUHook

+ (void)hookClass:(const char*)className
         selector:(SEL)selector
          options:(AspectOptions)options
            block:(id)block {
    Class class = objc_getClass(className);

    if (!class) {
        NSLog(PREFIX @"class %s not found.", className);
        return;
    }

    NSError* error = nil;

    id<AspectToken> token = [class aspect_hookSelector:selector
                                           withOptions:options
                                            usingBlock:block
                                                 error:&error];

    if (!token) {
        NSLog(PREFIX @"could not hook selector %@ of class %s",
              NSStringFromSelector(selector), className);
    } else {
        NSLog(PREFIX @"successfully hooked selector %@ of class %s",
              NSStringFromSelector(selector), className);
    }
}

@end
