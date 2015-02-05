//
//  DetailsViewController.h
//  MyWeatherApp
//
//  Created by osama mourad on 12/21/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherRecord.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface DetailsViewController : UITableViewController <UIScrollViewDelegate, ASIHTTPRequestDelegate, UINavigationBarDelegate> {
    NSDate *lastPageScroll; //date object to keep last time scroll view pulled down or up
    BOOL isUpdating;
    
    ASIFormDataRequest *req;
}

@property (strong, nonatomic) WeatherRecord *wr;

@end
