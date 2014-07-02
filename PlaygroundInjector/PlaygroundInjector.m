//
//  PlaygroundInjector.m
//  PlaygroundInjector
//
//  Created by Boris Bügling on 01/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>

#import "BBUHook.h"
#import "DVTSDK.h"

#define PlaygroundFrameworksPath    @"Library/Developer/Playground Frameworks"

static void **handle;

void InjectFrameworksIntoPlaygroundStub() {
#if 0
    NSString* bundleURLString = [NSProcessInfo processInfo].environment[@"PLAYGROUND_BUNDLE_URL"];
    NSString* bundlePath = [NSURL URLWithString:bundleURLString].path;
#endif

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:PlaygroundFrameworksPath];
            NSArray* list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];

            NSUInteger frameworkCount = [list count];
            handle = realloc(handle, frameworkCount * sizeof(void*));
            uint32_t index = 0;

            for (NSString* element in list) {
                NSString* sharedObjectName = [element stringByDeletingPathExtension];

                NSString* sharedObjectPath = [path stringByAppendingPathComponent:element];
                sharedObjectPath = [sharedObjectPath stringByAppendingPathComponent:@"Versions/A"];
                sharedObjectPath = [sharedObjectPath stringByAppendingPathComponent:sharedObjectName];

                handle[index] = dlopen([sharedObjectPath fileSystemRepresentation], RTLD_NOW);
                index++;
            }

            sleep(5);
        }
    });
}
