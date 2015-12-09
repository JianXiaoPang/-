//
//  FMDBUtility.h
//  musiring
//
//  Created by darkdong on 13-12-26.
//  Copyright (c) 2013年 paixiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDType.h"

@class FMDatabase, FMDatabaseQueue, FMResultSet;

extern NSString * const FMDBSeparator;
extern NSString * const FMDBPlaceholder;

extern NSString * const FMDBSchemaKeyColumnName;
extern NSString * const FMDBSchemaKeyColumnDataType;
extern NSString * const FMDBSchemaKeyColumnConstraint;

extern NSString * const FMDBDataTypeNULL;
extern NSString * const FMDBDataTypeINTEGER;
extern NSString * const FMDBDataTypeREAL;
extern NSString * const FMDBDataTypeTEXT;
extern NSString * const FMDBDataTypeBLOB;

extern NSString * const FMDBConstraintPRIMARYKEY;
extern NSString * const FMDBConstraintUNIQUE;;
extern NSString * const FMDBConstraintNOTNULL;

typedef void (^DDBlockFMDatabase)(FMDatabase *db);
typedef void (^DDBlockFMResultSet)(FMResultSet *resultSet);

BOOL FMDBCreateDBTable(FMDatabase *db, NSString *table, NSArray *schema);
void FMDBReplaceIntoTableSafely(NSString *table, NSDictionary *columns, FMDatabaseQueue *queue, DDBlockVoid completion);
void FMDBDeleteRowsFromTableSafely(NSString *table, NSString *whereClause, FMDatabaseQueue *queue, DDBlockVoid completion);
void FMDBReadRowFromTableSafely(NSString *table, NSString *whereClause, FMDatabaseQueue *queue, DDBlockFMResultSet completion);

@interface FMDBUtility : NSObject
+ (dispatch_queue_t)databaseQueue;
@end
