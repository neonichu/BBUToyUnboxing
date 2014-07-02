//
//  BBUToyUnboxing.m
//  BBUToyUnboxing
//
//  Created by Boris Bügling on 24/06/14.
//    Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUHook.h"
#import "BBUToyUnboxing.h"
#import "DVTSDK.h"
#import "IDEIndexSwiftDataSource.h"
#import "IDELocalComputerPlaygroundExecutionDeviceService.h"
#import "IDEPlaygroundExecutionSession.h"

#define PlaygroundFrameworksPath    @"Library/Developer/Playground Frameworks"

static BBUToyUnboxing *sharedPlugin;

@interface BBUToyUnboxing ()

@property (nonatomic, strong) NSBundle *bundle;

@end

#pragma mark -

@implementation BBUToyUnboxing

- (NSString*)getDerivedDataDirectoryWithPrefix:(NSString*)prefix {
    NSString* derivedDataPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Developer/Xcode/DerivedData"];
    NSArray* list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:derivedDataPath error:nil];

    for (NSString* element in list) {
        if ([element hasPrefix:prefix]) {
            return [derivedDataPath stringByAppendingPathComponent:element];
        }
    }

    return nil;
}

- (void)hookUpStuff {
    NSString* pathToFramework = [self getDerivedDataDirectoryWithPrefix:@"BBUToyUnboxing-"];
    pathToFramework = [pathToFramework stringByAppendingPathComponent:@"Build/Products/Debug/libPlaygroundInjector.dylib"];

    NSLog(PREFIX @"injecting %@ into Stub process.", pathToFramework);

    [BBUHook hookClass:"IDELocalComputerPlaygroundExecutionDeviceService"
              selector:@selector(sessionForExecutingPlaygroundWithParameters:)
               options:AspectPositionBefore
                 block:^(id<AspectInfo> info, id parameters) {
                     setenv("DYLD_INSERT_LIBRARIES", [pathToFramework fileSystemRepresentation], 1);
                 }];

    [BBUHook hookClass:"IDEPlaygroundExecutionSession"
              selector:@selector(cleanupExecutable)
               options:AspectPositionAfter
                 block:^(id<AspectInfo> info) {
                     setenv("DYLD_INSERT_LIBRARIES", "", 1);
                 }];

    [BBUHook hookClass:"DVTSDK"
              selector:@selector(librarySearchPaths)
               options:AspectPositionAfter
                 block:^(id<AspectInfo> info) {
                     NSArray* searchPaths = nil;
                     [info.originalInvocation getReturnValue:&searchPaths];

                     NSLog(PREFIX @"search paths: %@", searchPaths);
                 }];

    [BBUHook hookClass:"IDEPlaygroundExecutionDeviceService"
              selector:@selector(overridingPlaygroundSearchPath)
               options:AspectPositionInstead
                 block:^(id<AspectInfo> info) {
                     NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:PlaygroundFrameworksPath];
                     [info.originalInvocation setReturnValue:&path];

                     NSLog(PREFIX @"overridingPlaygroundSearchPath: %@", path);
                 }];

    [BBUHook hookClass:"IDEIndexSwiftDataSource"
              selector:@selector(handleSourceKitError:)
               options:AspectPositionAfter
                 block:^(id<AspectInfo> info, void* arg1) {
                     NSLog(PREFIX @"Argument 1: %@", arg1);
                 }];

    [BBUHook hookClass:"IDEIndexSwiftDataSource"
              selector:@selector(importedModule:moduleURL:settings:)
               options:AspectPositionAfter block:^(id<AspectInfo> info,
                                                   const char* module,
                                                   NSURL* moduleURL,
                                                   id settings) {
                   NSLog(PREFIX @"module: %s, URL: %@, settings: %@",
                         module, moduleURL, settings);
               }];
}

#pragma mark - Plugin lifecycle

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    } else {
        // Just to see if the Stub picks up plugins as well...
        NSString* processName = [[NSProcessInfo processInfo] processName];
        NSLog(PREFIX @"loaded into %@ (%@)", currentApplicationName, processName);
    }
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;

        [self performSelector:@selector(hookUpStuff) withObject:nil afterDelay:5.0];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
