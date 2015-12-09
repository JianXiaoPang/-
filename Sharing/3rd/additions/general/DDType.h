//
//  DDType.h
//  dd
//
//  Created by darkdong on 12-4-5.
//  Copyright (c) 2012年 PaiXiu. All rights reserved.
//

#ifndef dd_DDType_h
#define dd_DDType_h

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@class AFHTTPRequestOperation;

typedef void (^DDBlockVoid)(void);
typedef void (^DDBlockBool)(BOOL ok);
typedef void (^DDBlockImage)(UIImage *image);
typedef void (^DDBlockArray)(NSArray *array);
typedef void (^DDBlockCoordinate2D)(CLLocationCoordinate2D revisedCoordinate);
typedef void (^DDBlockObject)(id obj);
typedef void (^DDBlockData)(NSData *data);
typedef void (^DDBlockProgress)(float progress);
typedef void (^DDBlockError)(NSError *error);
typedef void (^DDBlockBoolAndObj)(BOOL ok,id obj);
typedef void (^DDBlockURL)(NSURL *url);
typedef void (^AFBlockSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^AFBlockFailure)(AFHTTPRequestOperation *operation, NSError *error);

#endif
