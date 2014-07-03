//
//  BBUToyUnboxing.m
//  BBUToyUnboxing
//
//  Created by Boris Bügling on 24/06/14.
//    Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "BBUHook.h"
#import "BBUToyUnboxing.h"
#import "IDELocalComputerPlaygroundExecutionDeviceService.h"
#import "IDEPlaygroundExecutionParameters.h"
#import "IDEPlaygroundExecutionSession.h"
#import "IDESourceLanguageServiceSwift.h"

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

    if (![[NSFileManager defaultManager] fileExistsAtPath:pathToFramework]) {
        pathToFramework = [self.bundle pathForResource:@"libPlaygroundInjector" ofType:@"dylib"];
    }

    NSLog(PREFIX @"injecting %@ into Stub process.", pathToFramework);

    __block NSURL* playgroundBundleURL = nil;

    [BBUHook hookClass:"IDELocalComputerPlaygroundExecutionDeviceService"
              selector:@selector(sessionForExecutingPlaygroundWithParameters:)
               options:AspectPositionBefore
                 block:^(id<AspectInfo> info, id parameters) {
                     setenv("DYLD_INSERT_LIBRARIES", [pathToFramework fileSystemRepresentation], 1);

                     if (playgroundBundleURL) {
                         setenv("PLAYGROUND_BUNDLE_URL",
                                [[playgroundBundleURL absoluteString]
                                 cStringUsingEncoding:NSUTF8StringEncoding], 1);
                     }
                 }];

    [BBUHook hookClass:"IDEPlaygroundExecutionSession"
              selector:@selector(cleanupExecutable)
               options:AspectPositionAfter
                 block:^(id<AspectInfo> info) {
                     setenv("DYLD_INSERT_LIBRARIES", "", 1);
                 }];

    [BBUHook hookClass:"IDEPlaygroundExecutionParameters"
              selector:@selector(initWithSourceCodeToExecute:documentFileURL:documentContentTimestamp:autoTerminationDelay:executionPreparationParameters:playgroundReportResultBlock:playgroundExecutionWillFinishBlock:playgroundExpressionCompleteBlock:errorHandlerBlock:)
               options:AspectPositionAfter
                 block:^(id<AspectInfo> info, NSString* sourceCode, NSURL* documentFileURL,
                         id timeStamp, unsigned long long delay, id parameters,
                         id resultBlock, id willFinishBlock, id completionBlock, id errorBlock) {
                     playgroundBundleURL = documentFileURL;
                 }];

    static NSString* const argumentsKey = @"swiftASTCommandArguments";
    static NSString* const buildSettingsKey = @"IDESourceLangaugeServiceContextBuildSettings";

    [BBUHook hookClass:"IDESourceLanguageServiceSwift"
              selector:@selector(_applyChangesFromSourceLanguageServiceContext:)
               options:AspectPositionInstead
                 block:^(id<AspectInfo> info, NSDictionary* context) {
                     NSString* bundlePath = [playgroundBundleURL.path stringByDeletingLastPathComponent];

                     NSMutableDictionary* mutableContext = [context mutableCopy];
                     NSMutableDictionary* mutableBuildSettings = [context[buildSettingsKey] mutableCopy];
                     NSMutableArray* mutableArguments = [mutableBuildSettings[argumentsKey] mutableCopy];

                     NSIndexSet* indexes = [mutableArguments indexesOfObjectsPassingTest:^BOOL(NSString* argument,
                                                                                               NSUInteger idx,
                                                                                               BOOL *stop) {
                         return [argument isEqualToString:@"-F"];
                     }];

                     NSUInteger insertionIndex = indexes.lastIndex + 2;
                     if (insertionIndex < mutableArguments.count) {
                         [mutableArguments insertObject:@"-F" atIndex:insertionIndex];
                         [mutableArguments insertObject:[NSHomeDirectory() stringByAppendingPathComponent:PlaygroundFrameworksPath] atIndex:insertionIndex + 1];

                         if (bundlePath) {
                             [mutableArguments insertObject:@"-F" atIndex:insertionIndex + 2];
                             [mutableArguments insertObject:bundlePath atIndex:insertionIndex + 3];
                         }
                     }

                     if (mutableArguments && mutableBuildSettings) {
                         mutableBuildSettings[argumentsKey] = [mutableArguments copy];
                         mutableContext[buildSettingsKey] = [mutableBuildSettings copy];

                         //NSLog(PREFIX @"Fixed context: %@", mutableContext);
                         [info.originalInvocation setArgument:&mutableContext atIndex:2];
                     }

                     [info.originalInvocation invoke];
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
