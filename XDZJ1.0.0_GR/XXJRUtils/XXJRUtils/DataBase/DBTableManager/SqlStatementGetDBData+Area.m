//
//  SqlStatement+Area.m
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "SqlStatementGetDBData+Area.h"

@implementation SqlStatementGetDBData (Area)

#pragma mark -
#pragma mark ==== Area ====
#pragma mark -
/**
 *	Description of Area from Api specification
 *
 *  "AreaId":"000400150008",
 *  "AreaName":"龙华新区",
 *  "AreaPinyin":"",
 *  "IsHotCity":"0",
 *  "OrderBy":"123456.00000000",
 *  "StatusCode":"1"
 *
 *  AreaID地区码，每4个表示一个层级，对应省-市-区-商圈的层级关系。如广东是0001，深圳是00010001，000100010001是罗湖，0001000100010001是华强北。
 *	AreaPinyin中文拼音。
 *	IsHotCity是否是热点城市。
 *	OrderBy地区排序值。
 *	StatusCode状态 1为正常，2为停用，3为删除。
 */
+ (NSString *)getCityListByCityId
{
    return @" "
    " SELECT rowid,* FROM [Area] WHERE [AreaId] = ? AND [StatusCode] = 1 ";
}

+ (NSString *)getCityList
{
//    rowid,
    return @" "
    " SELECT * FROM [Area] WHERE [StatusCode] = 1 AND length([AreaId]) = 8 "
    " ORDER BY [OrderBy] desc,[AreaPinyin],[AreaName]";
}

+ (NSString *)getCityIDList
{
    return @" "
    " SELECT AreaId FROM [Area] WHERE [StatusCode] =1 ";
}

+ (NSString *)getProvinceList
{
//    rowid,
    return @" "
    " SELECT * FROM [Area] WHERE [StatusCode] = 1 AND length(AreaId) = 8 "
    " ORDER BY [AreaId] desc, [AreaPinyin] ";
}

+ (NSString *)getCityListByProvinceId
{
//    rowid,
    return @" "
    " SELECT * FROM [Area] "
    " WHERE [StatusCode] = 1 AND substr([AreaId],1,4) = ? AND length([AreaId]) = 8 "
    " ORDER BY [AreaPinyin],[AreaName]";
}

+ (NSString *)getHotCityList
{
//    rowid,
    return @" "
    " SELECT * FROM [Area] "
    " WHERE IsHotCity = 1 AND [StatusCode] = 1 AND length(AreaId)=8 "
    " ORDER BY [OrderBy] desc, AreaPinyin,AreaName";
}

+ (NSString *)geCityForLevelThreeList
{
    return @" "
    " SELECT c.* FROM (SELECT * FROM [Area] WHERE AreaId = ? AND [StatusCode] = 1 ) AS s  "
    " LEFT JOIN (SELECT * FROM [Area] WHERE [StatusCode] = 1 and length(AreaId)=12 ) AS c  "
    " ON s.AreaId = substr(c.AreaId,1,8) "
    " WHERE length(c.AreaId) > 0 "
    " ORDER BY c.[OrderBy] desc";
}

+ (NSString *)geCityForLevelFourList
{
    return @" "
    " SELECT c.* FROM (SELECT * FROM [Area] WHERE AreaId = ? AND [StatusCode] = 1) AS s  "
    " LEFT JOIN (SELECT * FROM [Area] WHERE [StatusCode] = 1 and length(AreaId)=16 ) AS c  "
    " ON s.AreaId = substr(c.AreaId,1,8) ";
}

+ (NSString *)getDistrictIDByCityName
{
    return @" "
    " SELECT AreaId FROM [Area] WHERE AreaName = ?";
}

+ (NSString *)getCityByProvinceAndCityName
{
    return @" "
    " SELECT s.* FROM (SELECT * FROM [Area] WHERE AreaName = ? AND [StatusCode] = 1 "
    " AND length(AreaId)=8) AS s  "
    " LEFT JOIN (SELECT AreaId FROM [Area] WHERE AreaName = ? AND [StatusCode] = 1) AS province  "
    " ON substr(s.AreaId,1,4) = province.AreaId ";
}

+ (NSString *)getCityByProvinceAndCitySpell
{
    return @" "
    " SELECT s.* FROM (SELECT * FROM [Area] WHERE lower(AreaPinyin) = ? AND [StatusCode] = 1 "
    " AND length(AreaId)=8) AS s "
    " LEFT JOIN (SELECT AreaId FROM [Area] WHERE lower(AreaPinyin) = ? AND [StatusCode]=1) AS province"
    " ON substr(s.AreaId,1,4) = province.AreaId";
}


+ (NSString *)insertCity
{
    return @" "
    " INSERT INTO Area "
    "( "
    " AreaId, "
    " AreaName, "
    " AreaPinyin, "
    " IsHotCity, "
    " OrderBy, "
    " StatusCode "
    ") VALUES (?,?,?,?,?,?)";
}

+ (NSString *)deleteCityByCityId
{
    return @" "
    " DELETE FROM Area WHERE AreaId = ?";
}

+ (NSString *)updateCityByCityId
{
    return @" "
    " UPDATE Area SET  "
    " AreaName = ?,  "
    " AreaPinyin = ?,  "
    " IsHotCity = ?,  "
    " OrderBy = ?,  "
    " StatusCode = ?  "
    " WHERE AreaId = ?";
}

+ (NSString *)isCityExists
{
    return @" "
    " SELECT count(1) AS count FROM [Area] WHERE AreaId = ?";
}

@end
