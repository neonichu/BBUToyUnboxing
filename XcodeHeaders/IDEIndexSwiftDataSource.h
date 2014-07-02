/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "IDEIndexDataSource.h"

@class IDEIndexNewMainFile, IDEIndexingJob, NSMutableArray, NSMutableIndexSet, NSMutableSet;

struct CDStruct_3c4b7cd8;
struct sourcekitd_uid_s;

@interface IDEIndexSwiftDataSource : IDEIndexDataSource
{
    IDEIndexingJob *_job;
    IDEIndexNewMainFile *_mainFile;
    NSMutableSet *_importedModules;
    NSObject<OS_dispatch_queue> *_indexingQueue;
    NSObject<OS_dispatch_semaphore> *_requestSemaphore;
    int _nPendingRequests;
    NSObject<OS_dispatch_queue> *_cancelQueue;
    NSMutableArray *_cancelBlocks;
    BOOL _didCancel;
    BOOL _didCrash;
    NSMutableIndexSet *_linesWithRelatedSymbols;
    NSMutableSet *_referencesToSuppress;
}

+ (void)handleSourceKitError:(void *)arg1 crashed:(char *)arg2;
+ (id)dataSourceVersion;
+ (id)swiftLang;
+ (void)initialize;
+ (id)sourceCodeSymbolKindForSwiftSymbolKind:(int)arg1 extendedSymbolKind:(id *)arg2;
+ (int)swiftSymbolKindForUID:(struct sourcekitd_uid_s *)arg1 isDecl:(char *)arg2;
+ (void)initializeSwiftSymbolKinds;

- (BOOL)generateDataForJob:(id)arg1;
- (void)processSymbolArray:(struct CDStruct_3c4b7cd8)arg1 parentKind:(int)arg2 parent:(id)arg3 grandparent:(id)arg4 isRelated:(BOOL)arg5;
- (void)processImportArray:(struct CDStruct_3c4b7cd8)arg1;
- (void)importedModule:(const char *)arg1 moduleURL:(id)arg2 settings:(id)arg3;
- (void)createSymbolWithCName:(const char *)arg1 kind:(id)arg2 role:(int)arg3 resolution:(const char *)arg4 line:(long long)arg5 column:(long long)arg6 receiver:(const char *)arg7 container:(id)arg8 pSymbol:(id *)arg9;
- (void)cancelSourceKitRequests;
- (void)handleSourceKitError:(void *)arg1;
- (void)issueSourceKitRequest:(struct sourcekitd_uid_s *)arg1 requestBlock:(id)arg2 responseBlock:(void)arg3;

@end
