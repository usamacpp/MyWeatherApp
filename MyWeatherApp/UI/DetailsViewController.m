//
//  DetailsViewController.m
//  MyWeatherApp
//
//  Created by osama mourad on 12/21/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    lastPageScroll = [NSDate date];
    isUpdating = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    if(isUpdating)
        [req cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if(isUpdating)
        return NO;
    
    return YES;
}

#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //handle pull to refresh
    NSTimeInterval tint = [lastPageScroll timeIntervalSinceNow];
    
    if(fabs(tint) > 2.0f && isUpdating == NO)
    {
        NSLog(@"time interval since last scroll action = %f", fabs(tint));
        
        lastPageScroll = [NSDate date];
        
        if(scrollView.contentOffset.y < -15)
        {
            NSLog(@"refresh");
            [self.refreshControl beginRefreshing];
            isUpdating = YES;
            
            req = [ASIFormDataRequest requestWithURL:_wr.urlRequested];
            [req setDidFinishSelector:@selector(returnedWeather:)];
            [req setDidFailSelector:@selector(failedReturnedList:)];
            [req setDelegate:self];
            [req startAsynchronous];
        }
    }
}

#pragma mark - http request

-(void)returnedWeather:(ASIHTTPRequest*)request {
    
    [self.refreshControl endRefreshing];
    
    NSString *responseString = [request responseString];
    NSLog(@"http response = %@", responseString);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    
    if(dic != nil) {
        //if successful add to histroy then move to details view
        NSString *city = [_wr.city copy];
        _wr = nil;
        
        _wr = [[WeatherRecord alloc] init:dic];
        _wr.urlRequested = request.url;
        _wr.cityRequested = city;
        
        if(_wr != nil) {
            [self.tableView reloadData];
        }
    }
    
    isUpdating = NO;
}

-(void)failedReturnedList:(ASIHTTPRequest*)request {
    
    NSLog(@"Failed");
    [self.refreshControl endRefreshing];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to find any matching weather location to the query submitted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    isUpdating = NO;
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = _wr.city;
            cell.imageView.image = _wr.icon;
            break;
        case 1:
            cell.textLabel.text = [@"Observation Time: " stringByAppendingString: _wr.observationTime];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"Humidity: %i", _wr.humadity];
            break;
        case 3:
            cell.textLabel.text = [@"Weather Description: " stringByAppendingString: _wr.weatherDescription];
            break;
    }
    
    return cell;
}

@end
