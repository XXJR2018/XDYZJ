//
//  FMDatabase+PDUtilsExtras.m
//  EVTUtils
//
//  Created by xeonwell on 14-4-11.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "FMDatabase+PDUtilsExtras.h"
#import "FMDatabaseAdditions.h"

@implementation FMDatabase (PDUtilsExtras)

+ (BOOL)enableWALModeForDB:(NSString *)dbPath
{
    BOOL result = NO;
    FMDatabase *database = [[FMDatabase alloc] initWithPath:dbPath];
    if ([database open])
    {
        result = [[[database stringForQuery:@"PRAGMA journal_mode = WAL"] uppercaseString]
                       isEqualToString:@"WAL"];

        [database close];
    }

    return result;
}

@end
