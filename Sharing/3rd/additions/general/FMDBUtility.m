//
//  FMDBUtility.m
//  musiring
//
//  Created by darkdong on 13-12-26.
//  Copyright (c) 2013年 paixiu. All rights reserved.
//

#import "FMDBUtility.h"
#import "DDPreprocessMacro.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"

NSString * const FMDBSeparator = @",";
NSString * const FMDBPlaceholder = @"?";

NSString * const FMDBSchemaKeyColumnName = @"column_name";
NSString * const FMDBSchemaKeyColumnDataType = @"column_datatype";
NSString * const FMDBSchemaKeyColumnConstraint = @"column_constraint";

NSString * const FMDBDataTypeNULL = @"NULL";
NSString * const FMDBDataTypeINTEGER = @"INTEGER";
NSString * const FMDBDataTypeREAL = @"REAL";
NSString * const FMDBDataTypeTEXT = @"TEXT";
NSString * const FMDBDataTypeBLOB = @"BLOB";

NSString * const FMDBConstraintPRIMARYKEY = @"PRIMARY KEY";
NSString * const FMDBConstraintUNIQUE = @"UNIQUE";
NSString * const FMDBConstraintNOTNULL = @"NOT NULL";

BOOL FMDBCreateDBTable(FMDatabase *db, NSString *table, NSArray *schema)
{
    DDLogDetail(@"table %@ schema %@", table, schema);
    
    if (![db tableExists:table]) {
        //根据schema 创建表结构
        NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:schema.count];
        for (NSDictionary *dic in schema) {
            NSString *columnName = dic[FMDBSchemaKeyColumnName];
            NSString *columnDataType = dic[FMDBSchemaKeyColumnDataType];
            NSString *columnConstraint = dic[FMDBSchemaKeyColumnConstraint];
            if (!columnConstraint) {
                columnConstraint = @"";
            }
            NSString *parameter = [columnName stringByAppendingFormat:@" %@ %@", columnDataType, columnConstraint];
            [parameters addObject:parameter];
        }
        
        NSString *columns = [parameters componentsJoinedByString:FMDBSeparator];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", table, columns];
        return [db executeUpdate:sql];
    }
    return NO;
    //检查每个字段
//    for (NSDictionary *dic in schema) {
//        NSString *columnName = [dic objectForKey:FMDBSchemaKeyColumnName];
//        if (![db columnExists:columnName inTableWithName:table]) {
//            NSString *columnDatatype = dic[FMDBSchemaKeyColumnDatatype];
//            NSString *columnConstraint = dic[FMDBSchemaKeyColumnConstraint];
//            if (!columnConstraint) {
//                columnConstraint = @"";
//            }
//            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@ %@", table, columnName, columnDatatype, columnConstraint];
//            PXLog(@"add column %@ sql %@", columnName, sql);
//            PXAssert([db executeUpdate:sql])
//        }
//    }
}

void FMDBReplaceIntoTableSafely(NSString *table, NSDictionary *columns, FMDatabaseQueue *queue, DDBlockVoid completion)
{
    dispatch_async([FMDBUtility databaseQueue], ^{
        [queue inDatabase:^(FMDatabase *db) {
            DDLog(@"write db in FMDatabaseQueue");
            NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:columns.count];
            NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:columns.count];
            NSMutableArray *placeholders = [NSMutableArray arrayWithCapacity:columns.count];
            
            for (NSString *columnName in columns) {
                id columnValue = columns[columnName];
                NSString *parameter = [NSString stringWithFormat:@"%@", columnName];
                [parameters addObject:parameter];
                [placeholders addObject:FMDBPlaceholder];
                [arguments addObject:columnValue];
            }
            
            NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES (%@)", table, [parameters componentsJoinedByString:FMDBSeparator], [placeholders componentsJoinedByString:FMDBSeparator]];
            [db executeUpdate:sql withArgumentsInArray:arguments];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }];
    });
}

void FMDBDeleteRowsFromTableSafely(NSString *table, NSString *whereClause, FMDatabaseQueue *queue, DDBlockVoid completion)
{
    dispatch_async([FMDBUtility databaseQueue], ^{
        [queue inDatabase:^(FMDatabase *db) {
            DDLog(@"delete db in FMDatabaseQueue");
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", table, whereClause];
            [db executeUpdate:sql];
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }];
    });
}

void FMDBReadRowFromTableSafely(NSString *table, NSString *whereClause, FMDatabaseQueue *queue, DDBlockFMResultSet completion)
{
    dispatch_async([FMDBUtility databaseQueue], ^{
        [queue inDatabase:^(FMDatabase *db) {
            DDLog(@"read db in FMDatabaseQueue");
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@", table, whereClause];
            FMResultSet *resultSet = [db executeQuery:sql];
            completion(resultSet);
            [resultSet close];
        }];
    });
}



//FMResultSet* FMDBReadRowFromTable(NSString *table, FMDatabase *db, NSString *whereClause)
//{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@", table, whereClause];
//    FMResultSet *resultSet = [db executeQuery:sql];
//    return resultSet;
//}

@implementation FMDBUtility

+ (dispatch_queue_t)databaseQueue {
    static dispatch_queue_t sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = dispatch_queue_create("com.FMDBUtility.databaseQueue", NULL);
    });
    return sharedQueue;
}

@end
