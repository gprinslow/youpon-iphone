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
#import "TextEntryTableViewCell.h"

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
    
    //Format navigation bar
    self.title = NSLocalizedString(@"Login", @"Login");
    
    UIBarButtonItem *registrationButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(switchToRegistration)];
    
    self.navigationItem.rightBarButtonItem = registrationButtonItem;
    
    
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
    
    /*
     * Prepare data for LoginView
     * TODO: Improve security of stored username, password, pin (userDefaults unsecure)
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *rememberMe = [userDefaults objectForKey:@"rememberMe"];
    
    if ([rememberMe isEqualToString:@"TRUE"]) {
        NSString *hasAuthenticated = [userDefaults objectForKey:@"hasAuthenticated"];
        NSString *hasEstablishedPin = [userDefaults objectForKey:@"hasEstablishedPin"];
        
        if ([hasAuthenticated isEqualToString:@"TRUE"]) {
            NSString *authenticatedUsername = [userDefaults objectForKey:@"authenticatedUsername"];
            
            [self.data setValue:authenticatedUsername forKey:@"username"];
            
            if ([hasEstablishedPin isEqualToString:@"TRUE"]) {
                NSString *authenticatedPassword = [userDefaults objectForKey:@"authenticatedPassword"];
                
                [self.data setValue:authenticatedPassword forKey:@"password"];
            }
        }
        else {
            [self.data setValue:@"" forKey:@"username"];
            [self.data setValue:@"" forKey:@"password"];
        }
    }
    else {
        [self.data setValue:@"" forKey:@"username"];
        [self.data setValue:@"" forKey:@"password"];
    }
    
    
    //DEBUG: Remove
//    NSLog(@"%@", self.data);
//    NSArray *keys = [self.data allKeys];
//    
//    for (NSString *key in keys) {
//        NSLog(@"%@ is %@", key, [self.data objectForKey:key]);
//    }
    
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
    
    //Added - to refresh data upon return
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
    
    static NSString *LoginRootTableViewControllerCellIdentifier = @"LoginRootTableViewControllerCellIdentifier";
    
    if ([rowKey isEqualToString:@"password"]) {
        TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = rowLabel;
        
        cell.textField.adjustsFontSizeToFitWidth = TRUE;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.clearButtonMode = UITextFieldViewModeAlways;
        cell.textField.secureTextEntry = TRUE;
        
        cell.textField.text = [data valueForKey:rowKey];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
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

#pragma mark - Custom methods

- (IBAction)switchToRegistration {
    
    
    
}


@end
