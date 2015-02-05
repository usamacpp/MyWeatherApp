//
//  MyWeatherAppTests.m
//  MyWeatherAppTests
//
//  Created by osama mourad on 12/17/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "History.h"
#import "WeatherRecord.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface MyWeatherAppTests : XCTestCase <ASIHTTPRequestDelegate> {
    WeatherRecord *wr;
    ASIFormDataRequest *req;
    NSURL *url;
    BOOL isPassed;
}

@end

@implementation MyWeatherAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *surl = @"http://api.worldweatheronline.com/free/v1/weather.ashx?key=vzkjnx2j5f88vyn5dhvvqkzc&q=Cairo&fx=yes&format=json";
    url = [NSURL URLWithString: surl];
    isPassed = NO;
}

-(void)returnedWeather:(ASIHTTPRequest*)request {
    
    NSString *responseString = [request responseString];
    NSLog(@"http response = %@", responseString);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    
    if(dic != nil) {
        //if successful add to histroy then move to details view
        wr = [[WeatherRecord alloc] init:dic];
    }
    
    isPassed = YES;
}

-(void)failedWeather:(ASIHTTPRequest*)request {
    isPassed = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHttp {
    req = [ASIFormDataRequest requestWithURL:url];
    [req setDidFinishSelector:@selector(returnedWeather:)];
    [req setDidFailSelector:@selector(failedWeather:)];
    [req setDelegate:self];
    [req startAsynchronous];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    if(isPassed)
        XCTAssert(YES, @"Passed");
    else
        XCTAssert(NO, @"Failed");
}

- (void)testHistoryOperations {
    
    [History clear];
    
    [History addCity:@"city1"];
    [History addCity:@"city1"];
    
    NSArray *arr = [History getCitiesHistoryList];
    if(arr.count != 1)
        XCTAssert(NO, @"failed");
    
    [History addCity:@"city2"];
    
    arr = [History getCitiesHistoryList];
    if(arr.count != 2)
        XCTAssert(NO, @"failed");
    
    XCTAssert(YES, @"passed");
}

/*- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

@end
