//
//  NSWeatherRecord.h
//  MyWeatherApp
//
//  Created by osama mourad on 12/19/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WeatherRecord : NSObject

@property (strong, readonly) NSDictionary *weatherDictionary;

@property (strong) NSURL *urlRequested;
@property (strong) NSString *cityRequested;
@property (strong, readonly) NSString *city;
@property (strong, readonly) NSString *iconUrl;
@property (strong, readonly) UIImage *icon;
@property (strong, readonly) NSString *observationTime;
@property (readonly) int humadity;
@property (strong, readonly) NSString *weatherDescription;

-(id)init:(NSDictionary*)dic;

@end
