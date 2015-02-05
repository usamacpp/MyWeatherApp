//
//  ViewController.h
//  MyWeatherApp
//
//  Created by osama mourad on 12/17/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeatherRecord.h"
#import "ASIFormDataRequest.h"
#import "History.h"
#import "MBProgressHUD.h"
#import "DetailsViewController.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, UIGestureRecognizerDelegate> {
    
    WeatherRecord *wr;
    NSArray *citiesArray;
    NSMutableArray *filteredCitiesArray;
}

@property (strong, nonatomic) IBOutlet UITextField *searchCity;
@property (strong, nonatomic) IBOutlet UITableView *historyTableview;

- (IBAction)btnSearchPressed:(id)sender;
- (IBAction)textFieldLongPressed:(id)sender;
- (IBAction)textFieldChanged:(id)sender;

@end

