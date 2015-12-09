//
//  DDUtility.h
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "DDType.h"
#import "NSArray+Additions.h"

extern NSString * const DDArrayMergingModeKeyMaxID;
extern NSString * const DDArrayMergingModeKeyMinID;

//parse
BOOL DUObjectIsString(id obj);
BOOL DUObjectIsStringOrNumber(id obj);
id DUJSONObjectWithData(NSData *data);

//os info
BOOL DUDeviceIsLongScreen(void);
NSArray * DUGetAllFontNames(void);

//app info
NSString * DUGetAppVersion(void);

//dispatch queue
dispatch_queue_t DUDispatchGetMainQueue(void);
dispatch_queue_t DUDispatchGetGlobalQueue(void);

//string
NSString * DUGetStringFromFourCharCode(UInt32 fourCharCode);
NSComparisonResult DUVersionCompare(NSString *v1, NSString *v2);
BOOL DUSystemVersionGreatOrEqualTo(NSString *version);

//color
UIColor* DUGetTransparentColorForClick(void);

//file system
NSArray * DUFSGetOrderedFiles(NSString *directory, BOOL excludeHiddenFiles);
NSString * DUFSGetNextOrderPlistFilePath(NSString *directory);
void DUFSDeleteAllFilesInDirectory(NSString *directory);
unsigned long long DUFSGetDirectorySize(NSString *directory);
NSString * DUFSGetSizeString(unsigned long long size);

//merging array
NSDictionary * DUMakeArrayMergingModeInfo(NSArray *models, DDArrayMergingMode mode, SEL comparator, NSDictionary *customKeyInfo);

//AVFoundation
AVCaptureConnection * DUCaptureSessionGetConnection(AVCaptureSession *session, NSString *mediaType);
AVCaptureConnection * DUCaptureOutputGetConnection(AVCaptureOutput *output, NSString *mediaType);
AVCaptureDeviceInput * DUCaptureSessionGetDeviceInput(AVCaptureSession *session, NSString *mediaType);
AVCaptureOutput * DUCaptureSessionGetOutputByClass(AVCaptureSession *session, Class outputClass);
AVCaptureOutput * DUCaptureSessionGetOutput(AVCaptureSession *session, NSString *mediaType);
AVCaptureDevice * DUCaptureDeviceGetCamera(AVCaptureDevicePosition position);
AVCaptureDevicePosition DUCaptureDeviceGetCameraPosition(AVCaptureSession *session);
NSUInteger DUCaptureDeviceGetCameraCount(void);
void DUPlayWithVolume(AVPlayer *player, float volume);

AVCaptureConnection * DUCaptureSessionGetConnection(AVCaptureSession *session, NSString *mediaType);
AVCaptureDeviceInput * DUCaptureSessionGetDeviceInput(AVCaptureSession *session, NSString *mediaType);
AVCaptureOutput * DUCaptureSessionGetOutput(AVCaptureSession *session, NSString *mediaType);
AVCaptureDevice * DUCaptureDeviceGetCamera(AVCaptureDevicePosition position);
NSUInteger DUCaptureDeviceGetCameraCount(void);
UIImageOrientation DUCaptureOrientationConvertAVToImage(AVCaptureVideoOrientation avOrientation);
void DUPlayWithVolume(AVPlayer *player, float volume);
void DUPlayInSilentMode(void);

//photo
void DUAddGPSInfoToMetaData(CLLocation *location, NSMutableDictionary *metaData);
void DUAddImageOrientationToMetaData(UIImageOrientation imageOrientation, NSMutableDictionary *metaData);

//user defaults
NSUInteger DUUserDefaultsGetAllBitMask(void);
void DUUserDefaultsSetAllBitMask(NSUInteger allBitMask);
BOOL DUUserDefaultsHasBitMask(NSUInteger bitMask);
void DUUserDefaultsSetBitMask(NSUInteger bitMask, BOOL flag);

//view
void DUShowPopupView(UIView *popupView, float delta, float duration, DDBlockVoid completion);
void DUDismissPopupView(UIView *popupView, float delta, float duration, DDBlockVoid completion);
BOOL DUScrollViewIsCloseToBottom(UIScrollView *scrollView);
UIButton* DUMakeStretchableImageButton(NSString *imageName, NSString *highlightedImageName);
UIWindow* DUGetMainWindow(void);
//BOOL DUAlertViewExists(void);

//controller
id DUGetMainController(void);

@interface DDUtility : NSObject

+ (BOOL)monitorContainsObject:(NSUInteger)objectHashCode;
+ (void)monitorAddObject:(NSUInteger)objectHashCode;
+ (void)monitorRemoveObject:(NSUInteger)objectHashCode;

@end
