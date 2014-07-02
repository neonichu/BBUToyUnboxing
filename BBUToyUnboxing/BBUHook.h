//
//  BBUHook.h
//  BBUToyUnboxing
//
//  Created by Boris Bügling on 01/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Aspects.h"

#define PREFIX      @"toy-unboxing -- "

@interface BBUHook : NSObject

+ (void)hookClass:(const char*)className
         selector:(SEL)selector
          options:(AspectOptions)options
            block:(id)block;

@end
