//
//  History.h
//  MyWeatherApp
//
//  Created by osama mourad on 12/19/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

+(void)addCity:(NSString*)cityName;
+(NSArray*)getCitiesHistoryList;
+(void)clear;

@end
