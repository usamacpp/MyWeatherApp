//
//  NSWeatherRecord.m
//  MyWeatherApp
//
//  Created by osama mourad on 12/19/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "WeatherRecord.h"

@implementation WeatherRecord

-(id)init:(NSDictionary*)dic {
    
    if(self = [super init]) {
        _weatherDictionary = dic;
        
        NSDictionary *err = [[dic objectForKey:@"data"] objectForKey:@"error"];
        
        if(err == nil) {
            NSDictionary *req = [[[dic objectForKey: @"data"] objectForKey:@"request"] objectAtIndex:0];
            
            _city = [req objectForKey:@"query"];
            NSLog(@"city = %@", _city);
            
            NSDictionary *currCond = [[[dic objectForKey: @"data"] objectForKey:@"current_condition"] objectAtIndex:0];
            
            _iconUrl = [[[currCond objectForKey:@"weatherIconUrl"] objectAtIndex:0] objectForKey: @"value"];
            _icon = [WeatherRecord imageOfURL:_iconUrl];
            NSLog(@"icon url = %@", _iconUrl);
            
            _observationTime = [currCond objectForKey: @"observation_time"];
            NSLog(@"obs time = %@", _observationTime);
            
            _humadity = [[currCond objectForKey:@"humidity"] intValue];
            NSLog(@"humadity = %i", _humadity);
            
            _weatherDescription = [[[currCond objectForKey:@"weatherDesc"] objectAtIndex: 0] objectForKey:@"value"];
            NSLog(@"weather desc = %@", _weatherDescription);
        }
        else
        {
            NSLog(@"incorrect city name");
            self = nil;
        }
    }
    
    return self;
}

+(UIImage*)imageOfURL:(NSString*)surl
{
    @try {
        NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:surl]];
        return [UIImage imageWithData:data];
    }
    @catch (NSException *exception) {}
    
    return nil;
}

@end
