//
//  RegistrationRootTableViewController.m
//  Youpon
//
//  Created by Garrison on 8/11/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RegistrationRootTableViewController.h"
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"
#import "TableRowDetailEditController.h"
#import "TextEntryTableViewCell.h"


@implementation RegistrationRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [rowPlaceholderText release];
    [super dealloc];
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
    
    self.title = NSLocalizedString(@"Registration", @"Registration");
    
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRegistration)] autorelease];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    sectionNames = [[NSArray alloc] initWithObjects:
                    NSLocalizedString(@"Login Info", "Login Info"),
                    NSLocalizedString(@"Name", @"Name"),
                    NSLocalizedString(@"Demographics", @"Demographics"),
                    [NSNull null],
                    nil];
    
    rowLabels = [[NSArray alloc] initWithObjects:
                 
                 //Section 1 - Login
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Username", @"Username"),
                  NSLocalizedString(@"Password", @"Password"),
                  NSLocalizedString(@"Password", @"Password"),
                  NSLocalizedString(@"PIN", @"PIN"),
                  NSLocalizedString(@"Email", @"Email"),
                  NSLocalizedString(@"Remember Me", @"Remember Me"),
                  nil],
                 
                 //Section 2 - Name
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"First Name", @"First Name"),
                  NSLocalizedString(@"Middle Initial", @"Middle Initial"),
                  NSLocalizedString(@"Last Name", @"Last Name"),
                  nil],
                 
                 //Section 3 - Demographics
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Zip Code", @"Zip Code"),
                  NSLocalizedString(@"Birthday", @"Birthday"),
                  NSLocalizedString(@"Gender", @"Gender"),
                  NSLocalizedString(@"User Type", @"User Type"),
                  nil],
                    
                 //Section 4 - Registration Button
                 [NSArray arrayWithObjects:
                  [NSNull null],
                  nil],
                 
                 nil];
    
    rowKeys = [[NSArray alloc] initWithObjects:
                 
                 //Section 1 - Login
                 [NSArray arrayWithObjects:
                  @"username",
                  @"password",
                  @"passwordConfirm",
                  @"pin",
                  @"email",
                  @"rememberMe",
                  nil],
                 
                 //Section 2 - Name
                 [NSArray arrayWithObjects:
                  @"nameFirst",
                  @"nameMiddleInitial",
                  @"nameLast",
                  nil],
                 
                 //Section 3 - Demographics
                 [NSArray arrayWithObjects:
                  @"zipCode",
                  @"birthday",
                  @"gender",
                  @"userType",
                  nil],
                 
                 //Section 4 - Registration Button
                 [NSArray arrayWithObjects:
                  @"registrationButton",
                  nil],
                 
                 nil];
    
    rowPlaceholderText = [[NSArray alloc] initWithObjects:
                
                          //Section 1 - Login
                          [NSArray arrayWithObjects:
                           @"Enter a username (e.g. email address)",
                           @"Enter a password",
                           @"Confirm the password",
                           @"Enter a PIN for easier re-entry",
                           @"Enter a email address",
                           @"Remember your login info",
                           nil],
                          
                          //Section 2 - Name
                          [NSArray arrayWithObjects:
                           @"Enter your first name",
                           @"Optional",
                           @"Enter your last name",
                           nil],
                          
                          //Section 3 - Demographics
                          [NSArray arrayWithObjects:
                           @"Enter your home zip code",
                           @"Enter your birthday",
                           @"Enter your gender",
                           @"Select your user type",
                           nil],
                          
                          //Section 4 - Registration Button
                          [NSArray arrayWithObjects:
                           @"Register",
                           nil],
                          
                          nil];
    
    rowControllers = [[NSArray alloc] initWithObjects:
               
               //Section 1 - Login
               [NSArray arrayWithObjects:
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                @"SwitchTableViewCell",
                nil],
               
               //Section 2 - Name
               [NSArray arrayWithObjects:
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                @"TextEntryTableViewCell",
                nil],
               
               //Section 3 - Demographics
               [NSArray arrayWithObjects:
                @"TextEntryTableViewCell",
                @"TableRowDetailEditDateController",
                @"TableRowDetailEditSingleSelectionListController",
                @"TableRowDetailEditSingleSelectionListController",
                nil],
               
               //Section 4 - Registration Button
               [NSArray arrayWithObjects:
                @"ButtonTableViewCell",
                nil],
               
               nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                      
                      //Section 1 - Login
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       nil],
                      
                      //Section 2 - Name
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       [NSNull null],
                       nil],
                      
                      //Section 3 - Demographics
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSNull null],
                       [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Female", @"Male", @"Prefer not to say", nil] forKey:@"list"],
                       [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Customer", @"Business", @"Customer & Business", nil] forKey:@"list"],
                       nil],
                      
                      //Section 4 - Registration Button
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       nil],
                      
                      nil];    
    
    
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
    
    [self.tableView reloadData];
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
    return [sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    id rowController = [rowControllers nestedObjectAtIndexPath:indexPath];
    
    static NSString *RegistrationRootTableViewControllerCellIdentifier = @"RegistrationRootTableViewControllerCellIdentifier";
    
    if (rowController != [NSNull null]) {
        NSString *rowControllerString = (NSString *)rowController;
        
        if ([rowControllerString isEqualToString:@"TextEntryTableViewCell"]) {
            TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifier];
            
            if (cell == nil) {
                cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifier] autorelease];
            }
            
            //Text entry defaults - overridden by if statements below
            
            
            
        }
        else if ([rowControllerString isEqualToString:@"SwitchTableViewCell"]) {
            
        }
        else if ([rowControllerString isEqualToString:@"ButtonTableViewCell"]) {
            
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifier] autorelease];
            }
            
            id <StringValueDisplay, NSObject> rowValue = [data valueForKey:rowKey];
            
            cell.detailTextLabel.text = [rowValue stringValueDisplay];
            cell.textLabel.text = rowLabel;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifier] autorelease];
        }
        
        id <StringValueDisplay, NSObject> rowValue = [data valueForKey:rowKey];
        
        cell.detailTextLabel.text = [rowValue stringValueDisplay];
        cell.textLabel.text = rowLabel;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return nil;
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

#pragma mark - Table view - added methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id title = [sectionNames objectAtIndex:section];
    if ([title isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return title;
}


#pragma mark - Custom action methods

- (IBAction)startRegistrationAction {
    //TODO: Registration validation
    //TODO: Registration service call
    
    NSLog(@"Registration completed");
    
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelRegistration {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
