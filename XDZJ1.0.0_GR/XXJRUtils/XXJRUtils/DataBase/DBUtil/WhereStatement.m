//
//  WhereStatement.m
//  DBTest
//
//  Created by paidui-mini on 13-10-18.
//  Copyright (c) 2013年 paidui-mini. All rights reserved.
//

#import "WhereStatement.h"

@implementation WhereStatement

@synthesize key,operationType,linkType;

- (void)dealloc
{
    self.key = nil;
}

+ (WhereStatement *)instance
{
    return [[[self class] alloc]init];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey
{
    return [self instanceWithKey:mkey
                       operation:SqlOperationEqual
                    relationShip:SqlLinkRelationshipAnd];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey operation:(SqlOperationType)mType
{
    return [self instanceWithKey:mkey
                       operation:mType
                    relationShip:SqlLinkRelationshipAnd];
}

+ (WhereStatement *)instanceWithKey:(NSString *)mkey
                         operation:(SqlOperationType)mOperationType
                      relationShip:(SqlLinkRelationShipType)mlinkType
{
    WhereStatement *statement = [WhereStatement instance];
    statement.key = mkey;
    statement.operationType = mOperationType;
    statement.linkType = mlinkType;
    return statement;
}



@end
