//
//  LoginRootTableViewController.m
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "LoginRootTableViewController.h"
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"
#import "TableRowDetailEditController.h"

@implementation LoginRootTableViewController

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
    
    sectionNames = [[NSArray alloc] initWithObjects:
                    [NSNull null], 
                    NSLocalizedString(@"Options", @"Options"), 
                    [NSNull null], 
                    nil];
    
    rowLabels = [[NSArray alloc] initWithObjects:

                 //Section 1
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Username", @"Username"),
                  NSLocalizedString(@"Password", @"Password"),
                  NSLocalizedString(@"PIN", @"PIN"),
                  nil],
                 
                 //Section 2
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Remember Me", @"Remember Me"),
                  nil],
                 
                 //Section 3
                 [NSArray arrayWithObjects:@"",
                  nil],
                 
                 nil];
    
    rowKeys = [[NSArray alloc] initWithObjects:
               
               //Section 1
               [NSArray arrayWithObjects:
                @"username",
                @"password",
                @"pin",
                nil],
               
               //Section 2
               [NSArray arrayWithObject:
                @"rememberMe"],
               
               //Section 3
               [NSArray arrayWithObject:
                @"loginButton"],
               
               nil];
    
    rowControllers = [[NSArray alloc] initWithObjects:
                 
                 //Section 1
                 [NSArray arrayWithObjects:
                  @"TableRowDetailEditStringController",
                  @"TableRowDetailEditStringController",
                  @"TableRowDetailEditStringController",
                  nil],
                 
                 //Section 2
                 [NSArray arrayWithObject:@"TableRowDetailEditSingleSelectionListController"],
                 
                 //Section 3
                 [NSArray arrayWithObject:[NSNull null]],
                 
                 nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                      
                      //Section 1
                    [NSArray arrayWithObjects:
                     [NSNull null], 
                     [NSNull null],
                     [NSNull null],
                     nil],

                      //Section 2
                      [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Yes", @"No", nil] forKey:@"list"],
                      
                      //Section 3
                      [NSArray arrayWithObject:[NSNull null]],
                      
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
    static NSString *LoginRootTableViewControllerCellIdentifier = @"LoginRootTableViewControllerCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    //TODO: Conditional formatting of cells here
    id <StringValueDisplay, NSObject> rowValue = [data valueForKey:rowKey];
    
    cell.detailTextLabel.text = [rowValue stringValueDisplay];
    cell.textLabel.text = rowLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
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
    
    //Push editing controller onto stack
    NSString *controllerClassName = [rowControllers nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel  = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    
    //TODO: Conditional allocation of controllers here
    if (![controllerClassName isEqualToString:@"NSNull"]) {
        
        Class controllerClass = NSClassFromString(controllerClassName);
        TableRowDetailEditController *controller = [controllerClass alloc];
        controller = [controller initWithStyle:UITableViewStyleGrouped];
        controller.keyPath = rowKey;
        controller.data = self.data;
        controller.rowLabel = rowLabel;
        controller.title = rowLabel;
        
        NSDictionary *args = [rowArguments nestedObjectAtIndexPath:indexPath];
        if ([args isKindOfClass:[NSDictionary class]]) {
            if (args != nil) {
                for (NSString *oneKey in args) {
                    id oneArg = [args objectForKey:oneKey];
                    [controller setValue:oneArg forKey:oneKey];
                }
            }
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        
        [controller release];
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table view - added methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id title = [sectionNames objectAtIndex:section];
    if ([title isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return title;
}

@end
