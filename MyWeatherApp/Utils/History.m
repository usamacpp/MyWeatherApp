//
//  History.m
//  MyWeatherApp
//
//  Created by osama mourad on 12/19/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "History.h"

@implementation History

+(void)addCity:(NSString*)cityName {
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    NSString *hisList = [defs objectForKey:@"hist"];
    
    //if history list is not empty
    if(hisList != nil && ![hisList isEqualToString:@""]) {
        if([hisList rangeOfString:cityName].location == NSNotFound) {
            hisList = [hisList stringByAppendingString:@":"];
            hisList = [hisList stringByAppendingString:cityName];
            
            NSArray *arr = [hisList componentsSeparatedByString:@":"];
            
            // if more than 10 items in history list, remove latest one
            if(arr.count > 10) {
                hisList = [arr objectAtIndex: 1];
                for (int i = 2; i < 11; i++) {
                    hisList = [hisList stringByAppendingString:@":"];
                    hisList = [hisList stringByAppendingString:[arr objectAtIndex:i]];
                }
            }
            
            [defs setObject:hisList forKey:@"hist"];
        }
    }
    else { //create hisory list
        [defs setObject:cityName forKey:@"hist"];
    }
    
    [defs synchronize];
}

+(NSArray*)getCitiesHistoryList {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    
    NSString *hisList = [defs objectForKey:@"hist"];
    return [hisList componentsSeparatedByString:@":"];
}

+(void)clear {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:@"" forKey:@"hist"];
    [defs synchronize];
}

@end
