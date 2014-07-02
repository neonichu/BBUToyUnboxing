//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#pragma mark Blocks

typedef void (^CDUnknownBlockType)(void); // return type and parameters are unknown

#pragma mark -

@interface DVTPlaygroundCommunicationListener : NSObject

+ (id)_generateUniqueSocketPathWithError:(id *)arg1;

- (struct __CFSocket *)_lifetimeQueue_createSocket;
- (void)_listenerQueue_acceptSocketConnection:(int)arg1;
- (void)_listenerQueue_bytesAvailable;
- (void)_listenerQueue_endEncountered;
- (void)_listenerQueue_errorEncountered:(id)arg1;
- (void)_listenerQueue_listenForConnections;
- (void)_listenerQueue_openReadStream;
- (BOOL)_listenerQueue_readIntoBuffer:(char *)arg1 bufferLength:(long long)arg2 partiallyRecievedBufferIndexRef:(long long *)arg3;
- (void)_listenerQueue_setupReadStream;
- (void)_serializationQueue_closeSerialization;
- (void)_serializationQueue_serializeBuffer:(char *)arg1 bufferLength:(long long)arg2;
- (id)init;
- (void)replaySerializedEventsFromFile:(id)arg1 callbackQueue:(id)arg2 callbackBlock:(CDUnknownBlockType)arg3;
- (id)startListeningWithCallbackQueue:(id)arg1 serializingEventsToPath:(id)arg2 error:(id *)arg3 callbackBlock:(CDUnknownBlockType)arg4;
- (void)stopListening;

@end

#pragma mark -

@interface DVTPlaygroundCommunicationSender

+ (id)sharedPlaygroundCommunicationSender;

- (void)_senderQueue_addDataWrapperToQueue:(id)arg1;
- (void)_senderQueue_attemptToWrite;
- (void)_senderQueue_closeWriteStream;
- (void)_senderQueue_handleWriteStreamError;
- (BOOL)_senderQueue_openStreamWithError:(id *)arg1;
- (void)_senderQueue_removeDataWrapperFromQueueAtIndex:(unsigned long long)arg1;
- (void)_senderQueue_reportStreamClosedError:(CDUnknownBlockType)arg1;
- (void)_senderQueue_sendData:(id)arg1;
- (BOOL)_senderQueue_writeBuffer:(const char *)arg1 bufferLength:(unsigned long long)arg2 partiallySentBufferIndexRef:(long long *)arg3;
- (void)close;
- (void)dealloc;
- (id)init;
- (void)scheduleCompletionBlock:(CDUnknownBlockType)arg1 error:(id)arg2;
- (void)sendData:(id)arg1 metaData:(id)arg2 dataIdentifier:(id)arg3 version:(unsigned long long)arg4 isSerializable:(BOOL)arg5 completionBlock:(CDUnknownBlockType)arg6;

@end

#pragma mark -

@interface _DVTPlaygroundCommunicationSendDataWrapper

@property(readonly, copy) CDUnknownBlockType completionBlock; // @synthesize completionBlock=_completionBlock;
@property(readonly, copy) NSData *data; // @synthesize data=_data;
@property(readonly) NSString *dataIdentifier; // @synthesize dataIdentifier=_dataIdentifier;
@property(readonly) unsigned long long dataIdentifierLength; // @synthesize dataIdentifierLength=_dataIdentifierLength;
@property(readonly) char *dataIdentifierLengthBuffer;
@property(readonly) unsigned long long dataIdentifierLengthBufferLength; // @synthesize dataIdentifierLengthBufferLength=_dataIdentifierLengthBufferLength;
@property(readonly) char *dataLengthBuffer;
@property(readonly) unsigned long long dataLengthBufferLength; // @synthesize dataLengthBufferLength=_dataLengthBufferLength;
- (id)init;
- (id)initWithData:(id)arg1 metaData:(id)arg2 dataIdentifier:(id)arg3 version:(unsigned long long)arg4 timestamp:(double)arg5 isSerializable:(BOOL)arg6 completionBlock:(CDUnknownBlockType)arg7;
@property(readonly) char *isSerializableBuffer;
@property(readonly) unsigned long long isSerializableBufferLength; // @synthesize isSerializableBufferLength=_isSerializableBufferLength;
@property(readonly, copy) NSData *metaData; // @synthesize metaData=_metaData;
@property(readonly) char *metaDataLengthBuffer;
@property(readonly) unsigned long long metaDataLengthBufferLength; // @synthesize metaDataLengthBufferLength=_metaDataLengthBufferLength;
@property long long partiallySentDataIdentifierIndex; // @synthesize partiallySentDataIdentifierIndex=_partiallySentDataIdentifierIndex;
@property long long partiallySentDataIdentifierLengthBufferIndex; // @synthesize partiallySentDataIdentifierLengthBufferIndex=_partiallySentDataIdentifierLengthBufferIndex;
@property long long partiallySentDataIndex; // @synthesize partiallySentDataIndex=_partiallySentDataIndex;
@property long long partiallySentDataLengthBufferIndex; // @synthesize partiallySentDataLengthBufferIndex=_partiallySentDataLengthBufferIndex;
@property long long partiallySentIsSerializableBufferIndex; // @synthesize partiallySentIsSerializableBufferIndex=_partiallySentIsSerializableBufferIndex;
@property long long partiallySentMetaDataIndex; // @synthesize partiallySentMetaDataIndex=_partiallySentMetaDataIndex;
@property long long partiallySentMetaDataLengthBufferIndex; // @synthesize partiallySentMetaDataLengthBufferIndex=_partiallySentMetaDataLengthBufferIndex;
@property long long partiallySentTimestampBufferIndex; // @synthesize partiallySentTimestampBufferIndex=_partiallySentTimestampBufferIndex;
@property long long partiallySentVersionBufferIndex; // @synthesize partiallySentVersionBufferIndex=_partiallySentVersionBufferIndex;
@property(readonly) char *timestampBuffer;
@property(readonly) unsigned long long timestampBufferLength; // @synthesize timestampBufferLength=_timestampBufferLength;
@property(readonly) char *versionBuffer;
@property(readonly) unsigned long long versionBufferLength; // @synthesize versionBufferLength=_versionBufferLength;

@end
