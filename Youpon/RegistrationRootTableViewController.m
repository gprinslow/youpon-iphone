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

#define kUsernameCellTag 1
#define kPasswordCellTag 2
#define kPasswordConfirmCellTag 3
#define kPinCellTag 4
#define kEmailCellTag 5
#define kRememberMeCellTag 6
#define kNameFirstCellTag 7
#define kNameMiddleCellTag 8
#define kNameLastCellTag 9
#define kZipCodeCellTag 10
#define kBirthdayCellTag 11
#define kGenderCellTag 12
#define kUserTypeCellTag 13
#define kRegisterButtonCellTag 14

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
    [rowPlaceholders release];
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
    
    groupedEditTableView = (GroupedEditTableView *)self.tableView;
    
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
                  @"registerButton",
                  nil],
                 
                 nil];
    
    rowPlaceholders = [[NSArray alloc] initWithObjects:
                
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

            static NSString *RegistrationRootTableViewControllerCellIdentifierTxf = @"RegistrationRootTableViewControllerCellIdentifierTxf";
            
            TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifierTxf];
            
            if (cell == nil) {
                cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifierTxf] autorelease];
            }
            
            cell.textLabel.text = rowLabel;
            
            //Text entry defaults - overridden by if statements below
            cell.textField.adjustsFontSizeToFitWidth = TRUE;
            cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.textField.backgroundColor = [UIColor whiteColor];
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.secureTextEntry = FALSE;
            
            cell.textField.placeholder = [rowPlaceholders nestedObjectAtIndexPath:indexPath];
            cell.textField.text = [data valueForKey:rowKey];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([rowKey isEqualToString:@"username"]) {
                cell.tag = kUsernameCellTag;
                txfUsername = cell.textField;
            }
            else if ([rowKey isEqualToString:@"password"]){
                cell.tag = kPasswordCellTag;
                txfPassword = cell.textField;
            }
            else if ([rowKey isEqualToString:@"passwordConfirm"]) {
                cell.tag = kPasswordConfirmCellTag;
                txfPasswordConfirm = cell.textField;
            }
            else if ([rowKey isEqualToString:@"pin"]) {
                cell.tag = kPinCellTag;
                txfPin = cell.textField;
            }
            else if ([rowKey isEqualToString:@"email"]) {
                cell.tag = kEmailCellTag;
                txfEmail = cell.textField;
            }
            else if ([rowKey isEqualToString:@"nameFirst"]) {
                cell.tag = kNameFirstCellTag;
                txfNameFirst = cell.textField;
            }
            else if ([rowKey isEqualToString:@"nameMiddle"]) {
                cell.tag = kNameMiddleCellTag;
                txfNameMiddle = cell.textField;
            }
            else if ([rowKey isEqualToString:@"nameLast"]) {
                cell.tag = kNameLastCellTag;
                txfNameLast = cell.textField;
            }
            else if ([rowKey isEqualToString:@"zipCode"]) {
                cell.tag = kZipCodeCellTag;
                txfZipCode = cell.textField;
            }
            
            return cell;
        }
        else if ([rowControllerString isEqualToString:@"SwitchTableViewCell"]) {
            
            static NSString *RegistrationRootTableViewControllerCellIdentifierSwt = @"RegistrationRootTableViewControllerCellIdentifierSwt";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifierSwt];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifierSwt] autorelease];
            }
            
            CGFloat cellCenter = cell.frame.size.height/2.0;
            
            cell.detailTextLabel.text = rowLabel;
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0];
            
            if ([rowKey isEqualToString:@"rememberMe"]) {
                cell.tag = kRememberMeCellTag;
                
                UISwitch *rememberMeSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0f, cellCenter, 24.0f, 24.0f)] autorelease];
                [rememberMeSwitch addTarget:self action:@selector(rememberMeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = rememberMeSwitch;
                
                swtRememberMe = rememberMeSwitch;
            }
            
            return cell;
        }
        else if ([rowControllerString isEqualToString:@"ButtonTableViewCell"]) {
            
            static NSString *RegistrationRootTableViewControllerCellIdentifierBtn = @"RegistrationRootTableViewControllerCellIdentifierBtn";            
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistrationRootTableViewControllerCellIdentifierBtn];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:RegistrationRootTableViewControllerCellIdentifierBtn] autorelease];
            }
            
            CGFloat cellCenter = cell.frame.size.height/2.0;
            
            if ([rowKey isEqualToString:@"registerButton"]) {
                cell.tag = kRegisterButtonCellTag;
                
                UIActivityIndicatorView *registerActivityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
                [registerActivityIndicatorView setFrame:CGRectMake(0.0f, cellCenter, 24.0f, 24.0f)];
                cell.accessoryView = registerActivityIndicatorView;
                aivRegister = registerActivityIndicatorView;
                
                UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [registerButton addTarget:self action:@selector(startRegistrationAction) forControlEvents:UIControlEventTouchUpInside];
                [registerButton setTitle:@"Register" forState:UIControlStateNormal];
                registerButton.frame = CGRectMake(10.0f, 7.0f, 240.0f, 30.0f);
                [cell.contentView addSubview:registerButton];
                btnRegister = registerButton;
            }
            
            return cell;
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
    
    [groupedEditTableView resignAllFirstResponders];
    
    // Navigation logic may go here. Create and push another view controller.
    
    id controllerClassName = [rowControllers nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel  = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    
    //Conditional allocation of controllers here
    if (controllerClassName != [NSNull null]) {
        
        NSString *controllerClassString = (NSString *)controllerClassName;
        
        if (![controllerClassString isEqualToString:@"TextEntryTableViewCell"] && ![controllerClassString isEqualToString:@"SwitchTableViewCell"] && ![controllerClassString isEqualToString:@"ButtonTableViewCell"]) {
            
            Class controllerClass = NSClassFromString(controllerClassString);
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


#pragma mark - Custom action methods

- (IBAction)startRegistrationAction {
    //TODO: Registration validation
    //TODO: Registration service call
    
    [groupedEditTableView resignAllFirstResponders];
    
    NSLog(@"Registration request");
    
    [aivRegister startAnimating];
    
    [self performSelector:@selector(doRegistrationAction) withObject:nil afterDelay:0.5];
}

- (void)doRegistrationAction {
    
    if ([self isValidRegistrationAction]) {
        NSLog(@"Registration completed");
        
        [aivRegister stopAnimating];
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    
    [aivRegister stopAnimating];
}
- (BOOL)isValidRegistrationAction {
    
    return TRUE;
}

- (IBAction)cancelRegistration {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rememberMeSwitchValueChanged:(id)sender {
    
}

@end
