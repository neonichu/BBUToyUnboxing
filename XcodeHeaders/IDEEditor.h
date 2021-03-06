/*
 *     Generated by class-dump 3.3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2011 by Steve Nygard.
 */

#import "IDEViewController.h"

@class DVTFindBar, DVTNotificationToken, DVTObservingToken, DVTScopeBarsManager, IDEEditorContext, IDEEditorDocument, IDEFileTextSettings, NSScrollView;

@interface IDEEditor : IDEViewController

@property(retain) id delegate;
@property(retain, nonatomic) IDEFileTextSettings *fileTextSettings;
@property(retain, nonatomic) id findableObject;
@property(retain) IDEEditorContext *editorContext;
@property(retain) IDEEditorDocument *document;
@property(retain, nonatomic) IDEEditorDocument *documentForNavBarStructure;
@property BOOL discardsFindResultsWhenContentChanges;
@property(readonly) NSScrollView *mainScrollView;
@property(readonly) DVTScopeBarsManager *scopeBarsManager;
@property(readonly, getter=isPrimaryEditor) BOOL primaryEditor;
@property(readonly) DVTFindBar *findBar;
@property(readonly) BOOL findBarSupported;

+ (BOOL)canProvideCurrentSelectedItems;

- (id)relatedMenuItemsForNavItem:(id)arg1;
- (void)didSetupEditor;
- (void)navigateToAnnotationWithRepresentedObject:(id)arg1 wantsIndicatorAnimation:(BOOL)arg2 exploreAnnotationRepresentedObject:(id)arg3;
- (void)selectDocumentLocations:(id)arg1;
- (id)currentSelectedDocumentLocations;
- (id)currentSelectedItems;
- (void)primitiveInvalidate;
- (id)supplementalTargetForAction:(SEL)arg1 sender:(id)arg2;
- (void)setupContextMenuWithMenu:(id)arg1 withContext:(id)arg2;
- (void)takeFocus;
- (void)editorContextDidHideFindBar;
- (id)createFindBar;
- (id)_getUndoManager:(BOOL)arg1;
- (id)undoManager;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2 document:(id)arg3;
- (id)_initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)initUsingDefaultNib;

@end

