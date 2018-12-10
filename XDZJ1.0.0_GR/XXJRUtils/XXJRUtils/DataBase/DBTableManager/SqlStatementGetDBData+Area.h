//
//  SqlStatement+Area.h
//  PMH.DAL
//
//  Created by Desrie Qi on 13-8-7.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "SqlStatementGetDBData.h"
/*!
 @class SqlStatement (Area)
 @brief 城市表管理
 */
@interface SqlStatementGetDBData (Area)

/*!
 @brief Get city list by city id
 @return	NSString
 */
+ (NSString *)getCityListByCityId;

/*!
 @brief get a list of all cities
 @return	NSString
 */
+ (NSString *)getCityList;

/*!
 @brief get all city Ids list
 @return	NSString
 */
+ (NSString *)getCityIDList;

/*!
 @brief get a list of all province
 @return	NSString
 */
+ (NSString *)getProvinceList;

/*!
 @brief get a city list by the province Id
 @return	NSString
 */
+ (NSString *)getCityListByProvinceId;

/*!
 @brief get a list of hot cities
 @return	NSString
 */
+ (NSString *)getHotCityList;

/*!
 @brief get a city list of level three
 @return	NSString
 */
+ (NSString *)geCityForLevelThreeList;

/*!
 @brief get the district Id by the city name
 @return	NSString
 */
+ (NSString *)getDistrictIDByCityName;

/*!
 @brief get a list of cities at level for
 @return	NSString
 */
+ (NSString *)geCityForLevelFourList;

/*!
 @brief get the city by the province and city name
 @return	NSString
 */
+ (NSString *)getCityByProvinceAndCityName;

/*!
 @brief get city by the specll of province and city
 @return	NSString
 */
+ (NSString *)getCityByProvinceAndCitySpell;

/*!
 @brief     insert a city to database
 @return    NSString
 */
+ (NSString *)insertCity;

/*!
 @brief     delete a city form database
 @return    NSString
 */
+ (NSString *)deleteCityByCityId;


/*!
 @brief     update a city in database
 @return    NSString
 */
+ (NSString *)updateCityByCityId;

/**
 *	check whether the city is exist
 *
 *	@return	NSString
 */
+ (NSString *)isCityExists;

@end
