//
//  BBUToyUnboxing.m
//  BBUToyUnboxing
//
//  Created by Boris Bügling on 24/06/14.
//    Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import <objc/runtime.h>

#import "Aspects.h"
#import "BBUToyUnboxing.h"
#import "DVTLineOffsetAwareStringWrapper.h"
#import "IDELocalComputerPlaygroundExecutionDeviceService.h"
#import "IDEPlaygroundExecutionParameters.h"
#import "IDEPlaygroundExecutionSession.h"
#import "IDEPlaygroundPreparationParameters.h"

#define PREFIX      @"toy-unboxing -- "

static BBUToyUnboxing *sharedPlugin;

typedef void (^CDUnknownBlockType)(void); // return type and parameters are unknown

@interface NSObject ()

@property(readonly, copy) NSData *data;

-(BOOL)_listenerQueue_readIntoBuffer:(char *)arg1 bufferLength:(long long)arg2 partiallyRecievedBufferIndexRef:(long long *)arg3;

- (void)_senderQueue_addDataWrapperToQueue:(id)arg1;
-(void)_senderQueue_sendData:(id)arg1;
-(BOOL)_senderQueue_writeBuffer:(const char *)arg1 bufferLength:(unsigned long long)arg2 partiallySentBufferIndexRef:(long long *)arg3;
- (void)sendData:(id)arg1 metaData:(id)arg2 dataIdentifier:(id)arg3 version:(unsigned long long)arg4 isSerializable:(BOOL)arg5 completionBlock:(CDUnknownBlockType)arg6;

@end

#pragma mark -

@interface BBUToyUnboxing ()

@property (nonatomic, strong) NSBundle *bundle;

@end

#pragma mark -

@implementation BBUToyUnboxing

- (void)hookClass:(const char*)className selector:(SEL)selector options:(AspectOptions)options block:(id)block {
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

- (void)hookUpStuff
{
#if 0
    [self hookClass:"DVTPlaygroundCommunicationListener"
           selector:@selector(_listenerQueue_readIntoBuffer:bufferLength:partiallyRecievedBufferIndexRef:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, char* buffer, long long bufferLength, long long* idx) {
                  NSLog(PREFIX @"received buffer (%lld bytes) %s", bufferLength, buffer);
              }];
#endif

    [self hookClass:"DVTPlaygroundCommunicationSender"
           selector:@selector(_senderQueue_writeBuffer:bufferLength:partiallySentBufferIndexRef:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, const char* buffer, unsigned long long bufferLength, long long* idx) {
                  NSLog(PREFIX @"send buffer (%lld bytes) %s", bufferLength, buffer);
              }];

    [self hookClass:"DVTPlaygroundCommunicationSender"
           selector:@selector(_senderQueue_sendData:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, NSData* data) {
                  NSLog(PREFIX @"send buffer (%ld bytes) %@", data.length,
                        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
              }];

    [self hookClass:"DVTPlaygroundCommunicationSender"
           selector:@selector(_senderQueue_addDataWrapperToQueue:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, id dataWrapper) {
                  NSData* data = [dataWrapper data];
                  NSLog(PREFIX @"send buffer (%ld bytes) %@", data.length,
                        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
              }];

    [self hookClass:"DVTPlaygroundCommunicationSender"
           selector:@selector(sendData:metaData:dataIdentifier:version:isSerializable:completionBlock:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, NSData* data, NSData* metaData, id dataIdentifier,
                      unsigned long long version, BOOL isSerializable, CDUnknownBlockType block) {
                  NSLog(PREFIX @"send buffer (%ld bytes) %@", data.length,
                        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
              }];

#if 1
    [self hookClass:"IDEPlaygroundExecutionParameters"
           selector:@selector(initWithSourceCodeToExecute:documentFileURL:documentContentTimestamp:autoTerminationDelay:executionPreparationParameters:playgroundReportResultBlock:playgroundExecutionWillFinishBlock:playgroundExpressionCompleteBlock:errorHandlerBlock:)
            options:AspectPositionAfter
              block:^(id<AspectInfo> info, DVTLineOffsetAwareStringWrapper* sourceCode, NSURL* fileURL,
                      id timestamp, unsigned long long delay, id preparationParameters, id resultBlock,
                      id willFinishBlock, id completionBlock, id errorBlock) {
                  //NSString* actualSourceCode = sourceCode.string;
                  NSLog(PREFIX @"execution parameters: %@ %@ %@", fileURL, timestamp, sourceCode);
                  NSLog(PREFIX @"executable path: %@", [info.instance executablePath]);
              }];
#endif

    static NSString* const pathToExecutable = @"/Applications/Xcode6-Beta2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/PlaygroundStub_OSX";
    static NSString* const pathToFramework = @"/Applications/Xcode6-Beta2.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/ContentfulDeliveryAPI.framework/Versions/A/ContentfulDeliveryAPI";

    [self hookClass:"IDELocalComputerPlaygroundExecutionDeviceService" selector:@selector(sessionForExecutingPlaygroundWithParameters:) options:AspectPositionBefore block:^(id<AspectInfo> info, id parameters) {
        setenv("XCInjectBundle", [pathToFramework fileSystemRepresentation], 1);
        setenv("XCInjectBundleInto", [pathToExecutable fileSystemRepresentation], 1);

        setenv("DYLD_INSERT_LIBRARIES", [pathToFramework fileSystemRepresentation], 1);
    }];
}

#pragma mark - Plugin lifecycle

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    } else {
        NSString* processName = [[NSProcessInfo processInfo] processName];
        NSLog(PREFIX @"loaded into %@ (%@)", currentApplicationName, processName);
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;

        [self performSelector:@selector(hookUpStuff) withObject:nil afterDelay:5.0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
