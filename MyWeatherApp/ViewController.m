//
//  ViewController.m
//  MyWeatherApp
//
//  Created by osama mourad on 12/17/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //init filter list array
    filteredCitiesArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    //fetch history list
    citiesArray = [History getCitiesHistoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowDetails"]) {
        NSLog(@"show details");
        
        //pass weather record to details view
        ((DetailsViewController*)(segue.destinationViewController)).wr = wr;
    }
}

#pragma mark - auto complete results table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //count of filtered cities history list
    return filteredCitiesArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //values of filtered cities history list
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [filteredCitiesArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //when city name of history shown in the filtered list pressed, then should move to details view after getting weather record
    [_historyTableview setHidden:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *surl = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=vzkjnx2j5f88vyn5dhvvqkzc&q=%@&fx=yes&format=json", [filteredCitiesArray objectAtIndex:indexPath.row]];
    NSURL *reqUrl = [NSURL URLWithString: surl];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqUrl];
    [request setDidFinishSelector:@selector(returnedWeather:)];
    [request setDidFailSelector:@selector(failedReturnedList:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - http request

-(void)returnedWeather:(ASIHTTPRequest*)request {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *responseString = [request responseString];
    NSLog(@"http response = %@", responseString);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
    
    if(dic != nil) {
        //if successful add to histroy then move to details view
        wr = [[WeatherRecord alloc] init:dic];
        wr.cityRequested = self.searchCity.text;
        wr.urlRequested = request.url;
        
        if(wr != nil) {
            [History addCity: [wr.cityRequested lowercaseString]];
            [self performSegueWithIdentifier:@"ShowDetails" sender:self];
        }
        else
            [self showErrorMessage];
    }
}

-(void)failedReturnedList:(ASIHTTPRequest*)request {
    
    NSLog(@"Failed");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self showErrorMessage];
    
    NSLog(@"Error details = %@", [request.error description]);
}

-(void)showErrorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to find any matching weather location to the query submitted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

#pragma mark - text field

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //[_historyTableview setHidden:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_historyTableview setHidden:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchCity resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_searchCity isFirstResponder])
        [_searchCity resignFirstResponder];
    
    //[_historyTableview setHidden:YES];
}

- (IBAction)btnSearchPressed:(id)sender {
    [_searchCity resignFirstResponder];
    [_historyTableview setHidden:YES];
    
    //get weather record data from url
    NSString *surl = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=vzkjnx2j5f88vyn5dhvvqkzc&q=%@&fx=yes&format=json", self.searchCity.text];
    NSURL *reqUrl = [NSURL URLWithString: surl];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:reqUrl];
    [request setDidFinishSelector:@selector(returnedWeather:)];
    [request setDidFailSelector:@selector(failedReturnedList:)];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (IBAction)textFieldLongPressed:(id)sender {
    [_historyTableview setHidden:NO];
    
    [self filterContentForSearchText:self.searchCity.text];
    [self.historyTableview reloadData];
}

- (IBAction)textFieldChanged:(id)sender {
    NSLog(@"value changed");
    [self filterContentForSearchText:self.searchCity.text];
    [self.historyTableview reloadData];
}

-(void)filterContentForSearchText:(NSString*)searchText {
    [filteredCitiesArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    filteredCitiesArray = [NSMutableArray arrayWithArray:[citiesArray filteredArrayUsingPredicate:predicate]];
}

@end
