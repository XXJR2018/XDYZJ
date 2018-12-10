//
//  BaseDataDBHelper.m
//  PMH.DAL
//
//  Created by paidui-mini on 13-11-19.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "BaseDataDBHelper.h"
#import "BaseDataDBManager.h"

@implementation BaseDataDBHelper

- (FMDatabaseQueue *)instanceDBQueue
{
    FMDatabaseQueue *dbQueue = [BaseDataDBManager sharedBaseDataDBManager].dbQueue;
    return dbQueue;
}

@end
