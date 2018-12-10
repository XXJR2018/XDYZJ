//
//  BaseDataDBManager.m
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "BaseDataDBManager.h"
#import "FMDatabase+PDUtilsExtras.h"
#import "FMDatabaseQueue.h"
#import "SqlStatementCreatTable.h"

/**
 *	基础数据库名称
 */
#define BaseDataDBNAME      @"BaseData%ld.sqlite"
#define BaseDataDBNAMESHM   @"BaseData%ld.sqlite-shm"
#define BaseDataDBNAMEWAL   @"BaseData%ld.sqlite-wal"
#define kBaseDataDBVersionKey @"BaseDataDBVersionKey"
//#define kBaseDataDBDateKey @"1970-01-01 00:00:00"
#ifndef PDBaseDataDBVersion
#define PDBaseDataDBVersion 1
#endif

@interface BaseDataDBManager ()

/*!
 @property  NSString dbPath
 @brief     数据库完整路径
 */
@property (strong, nonatomic, readonly) NSString *dbPath;

/*!
 @brief     创建数据库，创建前先检查数据库是否存在，考虑修改为带参数是否覆盖
 */
- (void)createDataBase;

/*!
 @brief     判断文件是否存在，不存在时创建
 @return    BOOL DB文件是否存在
 */
- (BOOL)isDBExists;

/*!
 @brief     判断数据库版本是否相同
 @return    相同返回YES, 否则返回NO
 */
- (BOOL)isSameDBVersion;

/*!
 @brief     数据库升级
 @return    升级成功返回YES, 否则返回NO
 */
- (BOOL)updateDataBase;
/*!
 @brief     将数据库从指定低版本升级到高版本
 @param     oldDBVersion 旧版本号
 @param     latestDBVersion 升级的版本号
 */
- (void)updateDBFrom:(NSInteger)oldDBVersion to:(NSInteger)latestDBVersion;

/**
 *	删除旧版本数据库
 *
 *	@param	dbVersion	旧版本号
 */
- (void)removeDBFile:(NSInteger)dbVersion;
/**
 *	复制数据库到Document目录
 *
 *	@return	BOOL
 */
- (BOOL)copySourceDBFile;
@end

@implementation BaseDataDBManager
@synthesize dbQueue = _dbQueue;

#pragma mark -
#pragma mark ==== Properties ====
#pragma mark -

- (NSString *)dbPath
{
    return [XXJRUtils pathForResrouceInDocuments:DDG_str(BaseDataDBNAME,(long)PDBaseDataDBVersion)];  // PDBaseDataDBVersion 2
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil)
    {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
    }
    return _dbQueue;
}

#pragma mark -
#pragma mark ==== OverridesMethods ====
#pragma mark -

- (id)init
{
    if ((self = [super init]))
    {
        // Document目录下数据库不存在
        if (![self isDBExists])
        {
            [self createDataBase];
        }
        // Document目录下数据库已经存在
        else
        {
            if (![self isSameDBVersion])
            {
//                DDGDebugLog(@"current db version = %d",
//                           [[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey]);
                [self updateDataBase];
                
//                DDGDebugLog(@"new db version = %d", PDBaseDataDBVersion);
            }
        }
        // 转换到wal模式
        [FMDatabase enableWALModeForDB:self.dbPath];
    }
    return self;
}

#pragma mark -
#pragma mark ==== ClassMethods ====
#pragma mark -

__strong static BaseDataDBManager *_dbManager = nil;

DEFINE_SINGLETON_FOR_CLASS(BaseDataDBManager);

+ (void)resetDBManager
{
    _dbManager = nil;
}

- (void)createDataBase
{
    //判断Resource目录是否有数据库文件，有就copy到Document目录
    if ([self copySourceDBFile] == NO)
    {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:[SqlStatementCreatTable createUserTable]];
            [db executeUpdate:[SqlStatementCreatTable createUserBankCardTable]];
        }];
    }
//    //保存数据库版本号
//    [[NSUserDefaults standardUserDefaults] setInteger:PDBaseDataDBVersion forKey:kBaseDataDBVersionKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isDBExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];
}

- (BOOL)isSameDBVersion
{
    NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey];
    return dbVersion == PDBaseDataDBVersion;
}

- (BOOL)updateDataBase
{
    NSInteger dbVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kBaseDataDBVersionKey];
    
    if (dbVersion == PDBaseDataDBVersion) return YES;
    
    [self updateDBFrom:dbVersion to:PDBaseDataDBVersion];
    
    [[NSUserDefaults standardUserDefaults] setInteger:PDBaseDataDBVersion forKey:kBaseDataDBVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)removeDBFile:(NSInteger)dbVersion
{
    [[NSFileManager defaultManager] removeItemAtPath:
     [XXJRUtils pathForResrouceInDocuments:DDG_str(BaseDataDBNAME,(long)dbVersion)]
                                               error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:
     [XXJRUtils pathForResrouceInDocuments:DDG_str(BaseDataDBNAMESHM,(long)dbVersion)]
                                               error:NULL];

    [[NSFileManager defaultManager] removeItemAtPath:
     [XXJRUtils pathForResrouceInDocuments:DDG_str(BaseDataDBNAMEWAL,(long)dbVersion)]
                                               error:NULL];

}

/**
 *	复制数据库到Document目录
 *
 *	@return	BOOL
 */
- (BOOL)copySourceDBFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //Document路径中文件已存在
    if ([self isDBExists]) return YES;
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:DDG_str(BaseDataDBNAME,(long)PDBaseDataDBVersion)
                                                             ofType:nil];
    if ([fileManager fileExistsAtPath:resourcePath])
    {
        [fileManager copyItemAtPath:resourcePath toPath:self.dbPath error:&error];
        //复制成功
        if (error == nil)
        {
            NSLog(@"复制基础数据库成功");
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark ==== PublicMethods ====
#pragma mark -

- (void)handleDBError
{
    NSLog(@"db operation error occurred.");
}


#pragma mark -
#pragma mark ==== UpdateMethods ====
#pragma mark -
- (void)updateDBFrom:(NSInteger)oldDBVersion to:(NSInteger)latestDBVersion
{
    if (oldDBVersion == latestDBVersion) return;
    //删除旧的数据库
    [self removeDBFile:oldDBVersion];
    
    //创建新数据库
    [self createDataBase];
}
   
@end