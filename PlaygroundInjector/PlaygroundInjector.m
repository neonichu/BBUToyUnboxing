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

static NSArray* ListOfFrameworksAtPath(NSString* path) {
    NSArray* list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];

    NSMutableArray* mutableList = [@[] mutableCopy];
    for (NSString* possibleFramework in list) {
        if ([possibleFramework hasSuffix:@".framework"]) {
            NSString* frameworkPath = [path stringByAppendingPathComponent:possibleFramework];
            [mutableList addObject:frameworkPath];
        }
    }

    return [mutableList copy];
}

void InjectFrameworksIntoPlaygroundStub() {
    NSString* bundleURLString = [NSProcessInfo processInfo].environment[@"PLAYGROUND_BUNDLE_URL"];
    NSString* bundlePath = [[NSURL URLWithString:bundleURLString].path stringByDeletingLastPathComponent];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:PlaygroundFrameworksPath];

            NSMutableArray* allFrameworksToLoad = [@[] mutableCopy];
            [allFrameworksToLoad addObjectsFromArray:ListOfFrameworksAtPath(path)];
            [allFrameworksToLoad addObjectsFromArray:ListOfFrameworksAtPath(bundlePath)];

            NSUInteger frameworkCount = [allFrameworksToLoad count];
            handle = realloc(handle, frameworkCount * sizeof(void*));
            uint32_t index = 0;

            for (NSString* element in allFrameworksToLoad) {
                NSString* sharedObjectName = [element.lastPathComponent stringByDeletingPathExtension];

                NSString* sharedObjectPath = element;
                sharedObjectPath = [sharedObjectPath stringByAppendingPathComponent:@"Versions/A"];
                sharedObjectPath = [sharedObjectPath stringByAppendingPathComponent:sharedObjectName];

                //NSLog(PREFIX @"Loading shared object %@", sharedObjectPath);

                handle[index] = dlopen([sharedObjectPath fileSystemRepresentation], RTLD_NOW);
                index++;
            }

            sleep(5);
        }
    });
}
