//
//  OfferDetailTableViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/5/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "OfferDetailTableViewController.h"
#import "YouponAppDelegate.h"

UIAlertView *__offerDetailErrorAlertView;
UIAlertView *__activityAlertView;

static NSString *const RAILS_CREATE_REQUEST_NOTIFICATION = @"RAILS_CREATE_REQUEST_NOTIFICATION";

@implementation OfferDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //data will be initiated when controller is instantiated
    
    sectionHeaders = [[NSArray alloc] initWithObjects:
                      //Section 1: (no title - basics)
                      [NSNull null],
                      //Section 2:
                      NSLocalizedString(@"Details", @"Details"),
                      //Section 3:
                      NSLocalizedString(@"Terms & Conditions", @"Terms & Conditions"),
                      nil];
    //sectionFooters - NONE
    //rowLabels
    rowLabels = [[NSArray alloc] initWithObjects:
                 
                 //Section 1
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Title", @"Title"), 
                  NSLocalizedString(@"Byline", @"Byline"),
                                    nil],
                 
                 //Section 2 - Details
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Discount", @"Discount"),
                  NSLocalizedString(@"Category", @"Category"),
                  NSLocalizedString(@"Description", @"Description"), 
                  nil],
                 
                 //Section 3 - Terms & Conditions
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Terms", @"Terms"),
                  NSLocalizedString(@"# Offered", @"# Offered"),
                  NSLocalizedString(@"Start", @"Start"),
                  NSLocalizedString(@"End", @"End"),
                  nil],
                 
                 //Sentinel
                 nil];
    
    //rowKeys
    rowKeys = [[NSArray alloc] initWithObjects:
    
               //Section 1
               [NSArray arrayWithObjects:
                @"title",
                @"byline",
                nil],
               
               //Section 2 - Details
               [NSArray arrayWithObjects:
                @"discount",
                @"category",
                @"description", 
                nil],
               
               //Section 3 - Terms & Conditions
               [NSArray arrayWithObjects:
                @"terms",
                @"number_offered",
                @"start",
                @"end",
                nil],
               
               //Sentinel
               nil];
    
    //rowControllers
    rowControllers = [[NSArray alloc] initWithObjects:
               
               //Section 1
               [NSArray arrayWithObjects:
                [NSNull null],
                [NSNull null],
                nil],
               
               //Section 2 - Details
               [NSArray arrayWithObjects:
                [NSNull null],
                [NSNull null],
                [NSNull null],
                nil],
               
               //Section 3 - Terms & Conditions
               [NSArray arrayWithObjects:
                [NSNull null],
                [NSNull null],
                [NSNull null],
                [NSNull null],
                nil],
               
               //Sentinel
               nil];
    //rowArguments
    rowArguments = [[NSArray alloc] initWithObjects:
                      
                      //Section 1
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       nil],
                      
                      //Section 2 - Details
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       nil],
                      
                      //Section 3 - Terms & Conditions
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       nil],
                      
                      //Sentinel
                      nil];
    
    //TODO: Merchant info? - Must modify Rails and iOS
    
    self.title = [data valueForKey:@"title"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Redeem Now" 
                                              style:UIBarButtonItemStyleDone 
                                              target:self 
                                              action:@selector(redeemOffer:)];
    
    actRequestingRedemptionActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //Service delegate
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(redemptionRequestResponseReceived) 
     name:RAILS_CREATE_REQUEST_NOTIFICATION
     object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadTableViewData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OfferDetailTableViewControllerCellIdentifier = @"OfferDetailTableViewControllerCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OfferDetailTableViewControllerCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:OfferDetailTableViewControllerCellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    cell.textLabel.text = rowLabel;
    
    if ([rowKey isEqualToString:@"start"] || [rowKey isEqualToString:@"end"]) {
        NSString *dateString = [data objectForKey:rowKey];
        NSDateFormatter *dateFormatterToDate = [[NSDateFormatter alloc] init];
        [dateFormatterToDate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        NSDate *date = [dateFormatterToDate dateFromString:dateString];
        NSDateFormatter *dateFormatterToString = [[NSDateFormatter alloc] init];
        [dateFormatterToString setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
        cell.detailTextLabel.text = [dateFormatterToString stringFromDate:date];
        
        [dateFormatterToDate release];
        [dateFormatterToString release];
    }
    else {
        id <StringValueDisplay, NSObject> rowDetailValue = [data objectForKey:rowKey];
        cell.detailTextLabel.text = [rowDetailValue stringValueDisplay];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view - added methods (Titling the Sections)
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id title = [sectionHeaders objectAtIndex:section];
    if ([title isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    id title = [sectionFooters objectAtIndex:section];
    if ([title isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return title;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Table View - custom methods
-(void)reloadTableViewData {
    [self.tableView reloadData];
}

#pragma mark - UI Action methods
//Intercepts button action
-(IBAction)redeemOffer:(id)sender {
    NSLog(@"Offer redemption initiated");
    
    __activityAlertView = [[UIAlertView alloc] initWithFrame:CGRectMake(150, 150, 16, 16)];
    [__activityAlertView addSubview:actRequestingRedemptionActivityIndicator];
    [actRequestingRedemptionActivityIndicator startAnimating];
    [__activityAlertView show];
    [__activityAlertView release];
    
    [self performSelector:@selector(createRedemptionRequest) withObject:nil afterDelay:0.5];
}

-(IBAction)createRedemptionRequest:(id)sender {
    
    //Call service
    
    offerRedemptionRequest = [[RailsServiceRequest alloc] init];
    offerRedemptionResponse = [[RailsServiceResponse alloc] init];
    
    offerRedemptionRequest.requestActionCode = 4; //POST-create
    offerRedemptionRequest.requestModel = RAILS_MODEL_REQUESTS;
    offerRedemptionRequest.requestResponseNotificationName = RAILS_CREATE_REQUEST_NOTIFICATION;
    [offerRedemptionRequest.requestData setValue:data forKey:@"request"];
    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[delegate railsService] callServiceWithRequest:offerRedemptionRequest andResponsePointer:offerRedemptionResponse]) {
        NSLog(@"Called CreateRequest");
    }
    else {
        NSLog(@"Call to CreateRequest failed");
    }
}

//Service response delegate
-(void)redemptionRequestResponseReceived {
    //TODO: fill in redeemOffer - instantiate validateController & push
    
    NSLog(@"CreateRequest-ResponseReceived");
    
    for (id item in offerRedemptionResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    
    if ([offerRedemptionResponse.responseData objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[[offerRedemptionResponse responseData] objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
        
        [actRequestingRedemptionActivityIndicator stopAnimating];
        [__activityAlertView removeFromSuperview];
        
        [self alertViewForError:errorMessage title:@"Request Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else {
        //Successful request
        [data setValue:[offerRedemptionResponse responseData] forKey:@"request"];
        
        [actRequestingRedemptionActivityIndicator stopAnimating];
        [__activityAlertView removeFromSuperview];
        
        offerRedeemViewController = [[OfferRedeemViewController alloc] initWithNibName:@"OfferRedeemViewController" bundle:nil];
        
        //TODO: evaluate whether this should be pointer instead
        offerRedeemViewController.data = [[NSMutableDictionary alloc] initWithDictionary:data copyItems:YES];
        
        [self.navigationController pushViewController:offerRedeemViewController animated:YES];
    }
}

#pragma mark - Alert view methods
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __offerDetailErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__offerDetailErrorAlertView show];
    [__offerDetailErrorAlertView release];
    
    return FALSE;
}

@end
