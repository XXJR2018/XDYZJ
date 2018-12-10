//
//  BaseDataDBController.m
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "BaseDataDBController.h"
#import "BaseDataDBManager.h"

@implementation BaseDataDBController

@dynamic dbQueue;

- (FMDatabaseQueue *)dbQueue
{
    return [BaseDataDBManager sharedBaseDataDBManager].dbQueue;
}


+ (instancetype)dbController
{
    return [[self alloc] init];
}

- (id)init
{
    if (self = [super init])
    {
        _dbHelper = [[BaseDataDBHelper alloc] init];
    }
    return self;
}

@end
