//
//  DDUtility.m
//  dd
//
//  Created by darkdong on 13-3-19.
//  Copyright (c) 2013年 darkdong. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "DDUtility.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UIView+Additions.h"
#import "UIImage+Additions.h"
#import "DDGlobal.h"

NSString * const DDArrayMergingModeKeyMaxID = @"maxID";
NSString * const DDArrayMergingModeKeyMinID = @"minID";

static NSString *DUUserDefaultsKeyBitMask = @"BitMask";

#pragma mark - parse JSON

inline BOOL DUObjectIsString(id obj)
{
    return [obj isKindOfClass:[NSString class]];
}
inline BOOL DUObjectIsStringOrNumber(id obj)
{
    return [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]];
}

id DUJSONObjectWithData(NSData *data)
{
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

#pragma mark - os info

BOOL DUDeviceIsLongScreen(void)
{
    static BOOL isLongScreen = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isLongScreen = 568 == [UIScreen mainScreen].bounds.size.height;
    });
    
    return isLongScreen;
}

NSArray * DUGetAllFontNames(void)
{
    NSMutableArray *marray = [NSMutableArray array];
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *familyName in familyNames) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        mdic[familyName] = fontNames;
        [marray addObject:mdic];
    }
    return [marray copy];
}

#pragma mark - app info

NSString * DUGetAppVersion(void)
{
    static NSString *appVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *version = (__bridge NSString *)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), (CFStringRef)@"CFBundleShortVersionString");
        appVersion = [[NSString alloc] initWithString:version];
    });
    
    return appVersion;
}

#pragma mark - dispatch queue

inline dispatch_queue_t DUDispatchGetMainQueue(void)
{
    return dispatch_get_main_queue();
}

inline dispatch_queue_t DUDispatchGetGlobalQueue(void)
{
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

#pragma mark - string

NSString * DUGetStringFromFourCharCode(UInt32 fourCharCode)
{
    if (0 == fourCharCode) {
        return @"";
    }
    UInt32 beFormatID = CFSwapInt32HostToBig(fourCharCode);
    return [[NSString alloc] initWithBytes:&beFormatID length:sizeof(beFormatID) encoding:NSASCIIStringEncoding];
}

NSComparisonResult DUVersionCompare(NSString *v1, NSString *v2)
{
    return [v1 compare:v2 options:NSNumericSearch];
}

BOOL DUSystemVersionGreatOrEqualTo(NSString *version)
{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult result = [systemVersion compare:version options:NSNumericSearch];
    return (NSOrderedDescending == result || NSOrderedSame == result);
}

#pragma mark - color

UIColor* DUGetTransparentColorForClick(void)
{
    return RGBACOLOR(0, 0, 0, 0.01);
}

#pragma mark - file system

NSArray * DUFSGetOrderedFiles(NSString *directory, BOOL excludingHiddenFiles)
{
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
    if (error) {
        return nil;
    }
    NSMutableArray *mfiles = [files mutableCopy];
    if (excludingHiddenFiles) {
        NSIndexSet *indexes = [mfiles indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj hasPrefix:@"."];
        }];
        [mfiles removeObjectsAtIndexes:indexes];
    }
    [mfiles sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return [mfiles copy];
}

NSString * DUFSGetNextOrderPlistFilePath(NSString *directory)
{
    BOOL excludingHiddenFiles = YES;
    NSArray *files = DUFSGetOrderedFiles(directory, excludingHiddenFiles);
    NSString *fileName = [files lastObject];
    NSUInteger fileOrder = [[[fileName lastPathComponent] stringByDeletingPathExtension] integerValue];
    if (fileOrder >= 99999) {
        fileOrder = 1;
    }else {
        fileOrder++;
    }
    //00001-99999
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%05u", fileOrder]];
    return [filePath stringByAppendingPathExtension:@"plist"];
}

void DUFSDeleteAllFilesInDirectory(NSString *directory)
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *files = [defaultManager contentsOfDirectoryAtPath:directory error:NULL];
    for (NSString *fileName in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        [defaultManager removeItemAtPath:filePath error:NULL];
    }
}

unsigned long long DUFSGetDirectorySize(NSString *directory)
{
    unsigned long long int folderSize = 0;

    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSArray *files = [defaultManager contentsOfDirectoryAtPath:directory error:nil];
    
    for (NSString *fileName in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        NSDictionary *fileAttributes = [defaultManager attributesOfItemAtPath:filePath error:nil];
        unsigned long long fileSize = [fileAttributes[NSFileSize] unsignedLongLongValue];
        folderSize += fileSize;
    }
    return folderSize;
}

NSString * DUFSGetSizeString(unsigned long long size)
{
    if (size > 1024 * 1024) {
        unsigned long long mb = size / (1024 * 1024);
        return [NSString stringWithFormat:@"%llu M", mb];
    }else {
        unsigned long long kb = size / 1024;
        return [NSString stringWithFormat:@"%llu K", kb];
    }
}

#pragma mark - merging array

static NSDictionary * DUMakeModelMergingInfo(id model, SEL comparator, NSString *key)
{
    if ([model respondsToSelector:comparator]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSNumber *number = [model performSelector:comparator];
#pragma clang diagnostic pop
        if (number && key.length > 0) {
            return @{key: number};
        }
    }
    return nil;
}

NSDictionary * DUMakeArrayMergingModeInfo(NSArray *models, DDArrayMergingMode mode, SEL comparator, NSDictionary *customKeyInfo)
{
    if (0 == models.count) {
        return @{};
    }
    
    if(DDArrayMergingModeAppend == mode) {
        id model = models.lastObject;
        NSString *key = customKeyInfo[DDArrayMergingModeKeyMaxID];
        NSDictionary *info = DUMakeModelMergingInfo(model, comparator, key);
        if (info) {
            return info;
        }
    }else if(DDArrayMergingModePreappend == mode) {
        NSString *key = customKeyInfo[DDArrayMergingModeKeyMinID];
        for (id model in models) {
            NSDictionary *info = DUMakeModelMergingInfo(model, comparator, key);
            if (info) {
                return info;
            }
        }
    }
    return @{};
}

#pragma mark - AVFoundation

AVCaptureConnection * DUCaptureSessionGetConnection(AVCaptureSession *session, NSString *mediaType)
{
    for (AVCaptureOutput *output in session.outputs) {
        AVCaptureConnection *connection = DUCaptureOutputGetConnection(output, mediaType);
        if (connection) {
            return connection;
        }
    }
    return nil;
}

AVCaptureConnection * DUCaptureOutputGetConnection(AVCaptureOutput *output, NSString *mediaType)
{
    for (AVCaptureConnection *connection in output.connections) {
        for (AVCaptureInputPort *inputPort in connection.inputPorts) {
            if ([inputPort.mediaType isEqualToString:mediaType]) {
                return connection;
            }
        }
    }
    return nil;
}

AVCaptureDeviceInput * DUCaptureSessionGetDeviceInput(AVCaptureSession *session, NSString *mediaType)
{
    for (AVCaptureInput *input in session.inputs) {
        if ([input isKindOfClass:[AVCaptureDeviceInput class]]) {
            AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)input;
            AVCaptureDevice *device = deviceInput.device;
            if (device.connected && [device hasMediaType:mediaType]) {
                return deviceInput;
            }
        }
    }
    return nil;
}

AVCaptureOutput * DUCaptureSessionGetOutputByClass(AVCaptureSession *session, Class outputClass)
{
    for (AVCaptureOutput *output in session.outputs) {
        if ([output isKindOfClass:outputClass]) {
            return output;
        }
    }
    return nil;
}

AVCaptureOutput * DUCaptureSessionGetOutput(AVCaptureSession *session, NSString *mediaType)
{
    for (AVCaptureOutput *output in session.outputs) {
        //        AVCaptureConnection *connection = [output connectionWithMediaType:mediaType];
        //        if (connection) {
        //            return output;
        //        }
        for (AVCaptureConnection *connection in output.connections) {
            for (AVCaptureInputPort *inputPort in connection.inputPorts) {
                if ([inputPort.mediaType isEqualToString:mediaType]) {
                    return output;
                }
            }
        }
    }
    return nil;
}

AVCaptureDevice * DUCaptureDeviceGetCamera(AVCaptureDevicePosition position)
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

AVCaptureDevicePosition DUCaptureDeviceGetCameraPosition(AVCaptureSession *session)
{
    AVCaptureDeviceInput *videoInput = DUCaptureSessionGetDeviceInput(session, AVMediaTypeVideo);
    if (!videoInput) {
        return AVCaptureDevicePositionBack;
    }
    
    return videoInput.device.position;
}

NSUInteger DUCaptureDeviceGetCameraCount(void)
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

void DUPlayWithVolume(AVPlayer *player, float volume)
{
    NSArray *audioTracks = [player.currentItem.asset tracksWithMediaType:AVMediaTypeAudio];
    
    // Mute all the audio tracks
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
    [audioZeroMix setInputParameters:allAudioParams];
    
    [player.currentItem setAudioMix:audioZeroMix];
}

void DUPlayInSilentMode(void)
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    BOOL result = NO;
    if ([audioSession respondsToSelector:@selector(setActive:withOptions:error:)]) {
        result = [audioSession setActive:YES withOptions:0 error:&error]; // iOS6+
    } else {
        [audioSession setActive:YES withFlags:0 error:&error]; // iOS5 and below
    }
    if (!result && error) {
        // deal with the error
    }
    
    error = nil;
    result = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (!result && error) {
        // deal with the error
    }
}

#pragma mark - photo

void DUAddGPSInfoToMetaData(CLLocation *location, NSMutableDictionary *metaData)
{
    if (!location) {
        return;
    }
    if (-[location.timestamp timeIntervalSinceNow] > 60 * 60) {
        return;
    }
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];
    
    // GPS tag version
    [gps setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
    
    // Time and date must be provided as strings, not as an NSDate object
    NSDate *date = location.timestamp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [gps setObject:[formatter stringFromDate:date] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [gps setObject:[formatter stringFromDate:date] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    // Latitude
    CLLocationDegrees latitude = location.coordinate.latitude;
    if (latitude < 0) {
        latitude = -latitude;
        [gps setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [gps setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    
    // Longitude
    CLLocationDegrees longitude = location.coordinate.longitude;
    if (longitude < 0) {
        longitude = -longitude;
        [gps setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    } else {
        [gps setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    
    // Altitude
    CLLocationDistance altitude = location.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [gps setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [gps setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [gps setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Speed, must be converted from m/s to km/h
    CLLocationSpeed speed = location.speed;
    if (speed >= 0){
        [gps setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
        [gps setObject:[NSNumber numberWithFloat:speed * 3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
    }
    
    // Heading
    CLLocationDirection course = location.course;
    if (course >= 0){
        [gps setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
        [gps setObject:[NSNumber numberWithFloat:course] forKey:(NSString *)kCGImagePropertyGPSTrack];
    }
    [metaData setObject:gps forKey:(NSString*)kCGImagePropertyGPSDictionary];
}

void DUAddImageOrientationToMetaData(UIImageOrientation imageOrientation, NSMutableDictionary *metaData)
{
    //UIImageOrientationUp:             1
    //UIImageOrientationDown:           3
    //UIImageOrientationLeft:           8
    //UIImageOrientationRight:          6
    //UIImageOrientationUpMirrored:     2
    //UIImageOrientationDownMirrored:   4
    //UIImageOrientationLeftMirrored:   5
    //UIImageOrientationRightMirrored:  7
    
    NSArray *imgOri2PropOri = [NSArray arrayWithObjects:
                               [NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:3],
                               [NSNumber numberWithInt:8],
                               [NSNumber numberWithInt:6],
                               nil];
    if (imageOrientation < 4) {
        [metaData setObject:[imgOri2PropOri objectAtIndex:imageOrientation] forKey:(NSString*)kCGImagePropertyOrientation];
    }else {
        [metaData setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCGImagePropertyOrientation];
    }
}

#pragma mark - user defaults
//按位的布尔值
NSUInteger DUUserDefaultsGetAllBitMask(void)
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:DUUserDefaultsKeyBitMask];
}

void DUUserDefaultsSetAllBitMask(NSUInteger allBitMask)
{
    [[NSUserDefaults standardUserDefaults] setInteger:allBitMask forKey:DUUserDefaultsKeyBitMask];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

BOOL DUUserDefaultsHasBitMask(NSUInteger bitMask)
{
    NSUInteger allBitMask = DUUserDefaultsGetAllBitMask();
    return allBitMask & bitMask? YES: NO;
}

void DUUserDefaultsSetBitMask(NSUInteger bitMask, BOOL flag)
{
    NSInteger allBitMask = DUUserDefaultsGetAllBitMask();
    if (flag) {
        allBitMask |= bitMask;
    }else {
        allBitMask &= ~bitMask;
    }
    DUUserDefaultsSetAllBitMask(allBitMask);
}

#pragma mark - view

void DUShowPopupView(UIView *popupView, float delta, float duration, DDBlockVoid completion)
{    
    popupView.alpha = 0;
    popupView.top += delta;
    
    [UIView animateWithDuration:duration animations:^{
        popupView.alpha = 1;
        popupView.top -= delta;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

void DUDismissPopupView(UIView *popupView, float delta, float duration, DDBlockVoid completion)
{
    [UIView animateWithDuration:duration animations:^{
        popupView.alpha = 0;
        popupView.top += delta;
    } completion:^(BOOL finished) {
        if(completion) {
            completion();
        }
    }];
}

BOOL DUScrollViewIsCloseToBottom(UIScrollView *scrollView)
{
    return CGRectGetMaxY(scrollView.bounds) + scrollView.contentSize.height / 3 > scrollView.contentSize.height;
}

UIButton* DUMakeStretchableImageButton(NSString *imageName, NSString *highlightedImageName)
{
    UIImage *image = [UIImage stretchableImageNamedNoCache:imageName];
    UIImage *highlightedImage = [UIImage stretchableImageNamedNoCache:highlightedImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    return button;
}

UIWindow* DUGetMainWindow(void)
{
    id delegate = [[UIApplication sharedApplication] delegate];
    return [delegate window];
}

//BOOL DUAlertViewExists(void)
//{
//    if (!DUSystemVersionGreatOrEqualTo(@"7.0")) {
//        UIAlertView *topMostAlert = [NSClassFromString(@"_UIAlertManager") performSelector:@selector(topMostAlert)];
//        return !!topMostAlert;
//    }else {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        if (windows.count <= 1) {
//            return NO;
//        }
//        
//        UIWindow *window = windows[1];
//        NSArray *views = window.subviews;
//        if (views.count > 0) {
//            UIView *view = views[0];
//            BOOL hasAlert = [view isKindOfClass:[UIAlertView class]];
//            BOOL hasSheet = [view isKindOfClass:[UIActionSheet class]];
//            return hasAlert || hasSheet;
//        }
//        return NO;
//    }
//}
#pragma mark - controller

id DUGetMainController(void)
{
    UIWindow *window = DUGetMainWindow();
    UIViewController *rootController = window.rootViewController;
    if ([rootController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootController;
        if (navigationController.viewControllers.count > 0) {
            return navigationController.viewControllers[0];
        }
    }
    return nil;
}

@implementation DDUtility

+ (NSMutableSet *)monitor {
	static NSMutableSet *monitor = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        monitor = [[NSMutableSet alloc] init];
    });
    return monitor;
}

+ (BOOL)monitorContainsObject:(NSUInteger)objectHashCode {
    return [self.monitor containsObject:@(objectHashCode)];
}

+ (void)monitorAddObject:(NSUInteger)objectHashCode {
    [self.monitor addObject:@(objectHashCode)];
}

+ (void)monitorRemoveObject:(NSUInteger)objectHashCode {
    [self.monitor removeObject:@(objectHashCode)];
}


@end
