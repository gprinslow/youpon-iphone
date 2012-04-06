//
//  OffersRootTableViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 11/2/11.
//  Copyright (c) 2011 Garrison Prinslow. All rights reserved.
//

#import "OffersRootTableViewController.h"
#import "YouponAppDelegate.h"

//CONSTANTS
NSString *const GET_OFFERS_RESPONSE_NOTIFICATION_NAME = @"GET_OFFERS_RESPONSE";

UIAlertView *__offersErrorAlertView;

@implementation OffersRootTableViewController

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
    
    data = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    
    //TODO: Organize by headers (+footers?) based on category/distance etc.
    sectionHeaders = [[NSArray alloc] initWithObjects:
                      [NSNull null],
                      nil];
    
    sectionFooters = [[NSArray alloc] initWithObjects:
                      [NSNull null],
                      nil];
    
    
    self.title = @"Offers";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithTitle:@"Sign out"
                                             style:UIBarButtonItemStyleBordered 
                                             target:self
                                             action:@selector(doSignOut)];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                              target:self 
                                              action:@selector(refreshResults)];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(getOffersResponseReceived)
     name:GET_OFFERS_RESPONSE_NOTIFICATION_NAME
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
    
    [self refreshResults];
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
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OffersRootTableViewControllerCellIdentifier = @"OffersRootTableViewControllerCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OffersRootTableViewControllerCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:OffersRootTableViewControllerCellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    cell.textLabel.text = rowLabel;
    
    id <StringValueDisplay, NSObject> rowDetailValue = [[data objectForKey:rowKey] valueForKey:@"byline"];
    
    cell.detailTextLabel.text = [rowDetailValue stringValueDisplay];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    //Done confiiguring
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
                                              

#pragma mark - Methods for Rails Service handling
/*
 * RefreshResults - makes service call on load or upon hitting refresh button
 */
- (void)refreshResults {
    
    offersServiceRequest = [[RailsServiceRequest alloc] init];
    offersServiceResponse = [[RailsServiceResponse alloc] init];
    
    offersServiceRequest.requestActionCode = 0;
    offersServiceRequest.requestModel = RAILS_MODEL_OFFERS;
    offersServiceRequest.requestResponseNotificationName = GET_OFFERS_RESPONSE_NOTIFICATION_NAME;
    offersServiceRequest.requestData = self.data;
    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([delegate sessionToken] != nil) {
        if ([[delegate railsService] callServiceWithRequest:offersServiceRequest andResponsePointer:offersServiceResponse]) {
            NSLog(@"Called Get - Offers");
        }
        else {
            NSLog(@"Call Get - Offers Failed");
        }
    }
    else {
        NSLog(@"Must establish session token before calling get offers");
    }
}

/*
 * Called by notification center when get offers response received
 */
-(void)getOffersResponseReceived {
    
    NSLog(@"Get Offers Response Received");
    
    //TODO: remove debug log
    for (id item in offersServiceResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    
    //*  Step:  3)a: if failure, return alert message
    if ([[offersServiceResponse responseData] objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[offersServiceResponse.responseData objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
        
        [self alertViewForError:errorMessage title:@"Offers Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    //*  Step:  3)b: if success, sort and store data
    else {
        //Offers array is an array of NSDictionaries (each of which is an offer)
        NSArray *offers = [[offersServiceResponse responseData] objectForKey:@"items"];
        
        //Update title with count of offers retrieved
        NSString *newTitle = [[[NSString alloc] initWithFormat:@"Offers (%d)", offers.count] autorelease];
        [self setTitle:newTitle];
        
        //TODO: remove debug log statement
        for (id logitem in offers) {
            NSLog(@"%@", logitem);
        }
        
        /*
         * Data now contains all offers; key = id, value = offer (Dictionary)
         */
        for (NSDictionary *offer in offers) {
            [data setObject:offer forKey:[offer valueForKey:@"id"]];
        }
        
        //**HERE WOULD BE AN OUTER LOOP FOR SECTION**
        
        /*
         * rowKeys are an array of offer id's; rowKeys are sorted by offer(key).title
         * result is rowKeys contains the sorted order of offer.id
         */
        //TODO: if going to use sections, the keys need to be divided by section
        NSArray *sortedKeyArray = [self.data keysSortedByValueWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *sortString1 = [obj1 valueForKey:@"title"];
            NSString *sortString2 = [obj2 valueForKey:@"title"];
            
            return (NSComparisonResult)[sortString1 compare:sortString2 options:NSOrderedAscending];
        }];
        
        //TODO: if going to use sections, the keys need to be divided by section
        rowKeys = [[NSArray alloc] initWithObjects:
                   [[NSArray alloc] initWithArray:sortedKeyArray copyItems:YES], 
                   nil];
        
        /*
         * rowLabels are the titles used for each cell (row)
         * here it iterates through each to set the label in sorted order from keys
         */
        //TODO: evaluate this for leaks
        //TODO: if going to use sections, the keys need to be divided by section
        NSMutableArray *sortedLabels = [[NSMutableArray alloc] initWithCapacity:rowKeys.count];
        NSArray *sectionKeys = [rowKeys objectAtIndex:0];
        
        for (NSString *key in sectionKeys) {
            NSDictionary *offer = [data objectForKey:key];
            NSString *label = [offer objectForKey:@"title"];
            [sortedLabels addObject:label];
        }
        rowLabels = [[NSArray alloc] initWithObjects:
                     [[NSArray alloc] initWithArray:sortedLabels copyItems:YES], 
                     nil];
        
        //**END OUTER LOOP FOR SECION**
        
        
        //END: call reload of table view data
        [self reloadTableViewData];
    }
}

/*
 * Do reloading of table view data
 */
- (void)reloadTableViewData {
    [self.tableView reloadData];
}

- (void)doSignOut {
    //TODO: fix signout
    NSLog(@"TODO: fix signout");
}


#pragma mark Alert view
/*
 * Alert View for Errors
 */
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __offersErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__offersErrorAlertView show];
    [__offersErrorAlertView release];
    
    return FALSE;
}


@end
