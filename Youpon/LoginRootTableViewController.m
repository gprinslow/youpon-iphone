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
#import "YouponAppDelegate.h"


static NSString *const RAILS_GET_INDEX_USERS_NOTIFICATION = @"RAILS_GET_INDEX_USERS_NOTIFICATION";

UIAlertView *__loginErrorAlertView;

@implementation LoginRootTableViewController

@synthesize registrationRootTableViewController = _registrationRootTableViewController;

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
    self.title = NSLocalizedString(@"Youpon - Login", @"Login Page Title");
    
    UIBarButtonItem *registrationButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(switchToRegistration)];
    
    self.navigationItem.rightBarButtonItem = registrationButtonItem;
    
    
    sectionNames = [[NSArray alloc] initWithObjects:
                    [NSNull null],
                    NSLocalizedString(@"Options", @"Options"), 
                    nil];
    
    rowLabels = [[NSArray alloc] initWithObjects:

                 //Section 1
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Username", @"Username"),
                  NSLocalizedString(@"Password", @"Password"),
                  NSLocalizedString(@"PIN", @"PIN"),
                  NSLocalizedString(@"", @"LoginButton"),
                  nil],
                 
                 //Section 2
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Remember Me", @"Remember Me"),
                  nil],
                 
                 nil];
    
    rowKeys = [[NSArray alloc] initWithObjects:
               
               //Section 1
               [NSArray arrayWithObjects:
                @"username",
                @"password",
                @"pin",
                @"loginButton",
                nil],
               
               //Section 2
               [NSArray arrayWithObject:
                @"rememberMe"],
               
               nil];
    
    rowControllers = [[NSArray alloc] initWithObjects:
                 
                 //Section 1
                 [NSArray arrayWithObjects:
                  [NSNull null],
                  [NSNull null],
                  [NSNull null],
                  [NSNull null],
                  nil],
                 
                 //Section 2
                 [NSArray arrayWithObject:[NSNull null]],
                 
                 nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                      
                      //Section 1
                    [NSArray arrayWithObjects:
                     [NSNull null], 
                     [NSNull null],
                     [NSNull null],
                     [NSNull null],
                     nil],

                      //Section 2
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
            
            //Move control to Password field
            [txfPassword becomeFirstResponder];
            
            if ([hasEstablishedPin isEqualToString:@"TRUE"]) {
                NSString *authenticatedPassword = [userDefaults objectForKey:@"authenticatedPassword"];
                
                [self.data setValue:authenticatedPassword forKey:@"password"];
                
                //Move control to PIN field
                [txfPin becomeFirstResponder];
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
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(getIndexResponseReceived) 
     name:RAILS_GET_INDEX_USERS_NOTIFICATION 
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
    
    if ([rowKey isEqualToString:@"username"]) {
        TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = rowLabel;
        
        cell.textField.adjustsFontSizeToFitWidth = TRUE;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.secureTextEntry = FALSE;
        
        cell.textField.placeholder = @"Enter your username";
        
        cell.textField.text = [data valueForKey:rowKey];
        
        txfUsername = cell.textField;
        [txfUsername addTarget:self action:@selector(usernameEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        return cell;
    }
    else if ([rowKey isEqualToString:@"password"]) {
        TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = rowLabel;
        
        cell.textField.adjustsFontSizeToFitWidth = TRUE;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.secureTextEntry = TRUE;
        
        cell.textField.placeholder = @"Enter your password";
        
        cell.textField.text = [data valueForKey:rowKey];
        
        txfPassword = cell.textField;
        [txfPassword addTarget:self action:@selector(passwordEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        return cell;
    }
    else if ([rowKey isEqualToString:@"pin"]) {
        TextEntryTableViewCell *cell = (TextEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        cell.textLabel.text = rowLabel;
        
        cell.textField.adjustsFontSizeToFitWidth = FALSE;
        cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.secureTextEntry = TRUE;
        
        cell.textField.placeholder = @"Enter your PIN";
        
        cell.textField.text = [data valueForKey:rowKey];
        
        txfPin = cell.textField;
        cell.tag = 1;
        
        [txfPin addTarget:self action:@selector(pinEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        return cell;
    }
    else if ([rowKey isEqualToString:@"loginButton"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        CGFloat cellCenter = cell.frame.size.height/2.0;
        
        UIActivityIndicatorView *loginActivityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [loginActivityIndicatorView setFrame:CGRectMake(0.0f, cellCenter, 24.0f, 24.0f)];
        cell.accessoryView = loginActivityIndicatorView;
        aivLogin = loginActivityIndicatorView;
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton addTarget:self action:@selector(startLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        loginButton.frame = CGRectMake(50.0f, 7.0f, 200.0f, 30.0f);
        [cell.contentView addSubview:loginButton];
        btnLogin = loginButton;
        
        return cell;
    }
    else if ([rowKey isEqualToString:@"rememberMe"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginRootTableViewControllerCellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:LoginRootTableViewControllerCellIdentifier] autorelease];
        }
        
        CGFloat cellCenter = cell.frame.size.height/2.0;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *rememberMe = [userDefaults objectForKey:@"rememberMe"];
        
        cell.detailTextLabel.text = rowLabel;
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0];
        
        UISwitch *rememberMeSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0f, cellCenter, 24.0f, 24.0f)] autorelease];
        [rememberMeSwitch addTarget:self action:@selector(rememberMeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([rememberMe isEqualToString:@"TRUE"]) {
            [rememberMeSwitch setOn:YES animated:FALSE];
        }
        else {
            [rememberMeSwitch setOn:NO animated:FALSE];
        }
        
        cell.accessoryView = rememberMeSwitch;
        
        swtRememberMe = rememberMeSwitch;
        
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

    id controllerClassName = [rowControllers nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel  = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    
    //Conditional allocation of controllers here
    if (controllerClassName != [NSNull null]) {
        
        NSString *controllerClassString = (NSString *)controllerClassName;
        
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
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if ([rowKey isEqualToString:@"username"]) {
            [txfUsername becomeFirstResponder];
        }
        else if ([rowKey isEqualToString:@"password"]) {
            [txfPassword becomeFirstResponder];
        }
        else if ([rowKey isEqualToString:@"pin"]) {
            [txfPin becomeFirstResponder];
        }
        else if ([rowKey isEqualToString:@"loginButton"]) {
            [txfUsername resignFirstResponder];
            [txfPassword resignFirstResponder];
            [txfPin resignFirstResponder];
            
            if ([btnLogin isEnabled]) {
                [self startLoginAction];
            }
        }
        else if ([rowKey isEqualToString:@"rememberMe"]) {
            [txfUsername resignFirstResponder];
            [txfPassword resignFirstResponder];
            [txfPin resignFirstResponder];
            
            [swtRememberMe setOn:![swtRememberMe isOn] animated:YES];
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

#pragma mark - Action methods for resigning keyboard

- (IBAction)usernameEditingDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
    
    [[self data] setValue:txfUsername.text forKey:@"username"];
    
    [txfPassword becomeFirstResponder];
}
- (IBAction)passwordEditingDidEndOnExit:(id)sender {
    
    [[self data] setValue:txfPassword.text forKey:@"password"];
    
    [sender resignFirstResponder];
}
- (IBAction)pinEditingDidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}
         
#pragma mark - Action methods for responding to value changed

- (IBAction)rememberMeSwitchValueChanged:(id)sender {
    if (![swtRememberMe isOn]) {
        [txfPin setText:@""];
        [txfPin setPlaceholder:@"Disabled"];
        [txfPin setEnabled:FALSE];
    }
    else {
        [txfPin setPlaceholder:@"Enter your PIN"];
        [txfPin setEnabled:TRUE];
    }
}

#pragma mark - Disable and Enable Interactions

- (void)disableInteractions {
    [btnLogin setEnabled:FALSE];
    [txfUsername setEnabled:FALSE];
    [txfPassword setEnabled:FALSE];
    [txfPin setEnabled:FALSE];
    
    [self.tableView setUserInteractionEnabled:FALSE];    
    [self.tableView setAllowsSelection:FALSE];
}

- (void)enableInteractions {
    [btnLogin setEnabled:TRUE];
    [txfUsername setEnabled:TRUE];
    [txfPassword setEnabled:TRUE];
    [txfPin setEnabled:TRUE];
    
    [self.tableView setUserInteractionEnabled:TRUE];
    [self.tableView setAllowsSelection:TRUE];
}


#pragma mark - Custom methods

- (IBAction)switchToRegistration {
    //TODO: Switch to Registration screen
    
    self.registrationRootTableViewController = [[RegistrationRootTableViewController alloc] initWithNibName:@"RegistrationRootTableViewController" bundle:nil];
    
    self.registrationRootTableViewController.data = self.data;
    
    [self.navigationController pushViewController:self.registrationRootTableViewController animated:YES];
}

- (IBAction)startLoginAction {
    [txfUsername resignFirstResponder];
    [txfPassword resignFirstResponder];
    [txfPin resignFirstResponder];
    
    [aivLogin startAnimating];
    
    [self performSelector:@selector(doLoginAction) withObject:nil afterDelay:0.5];
}

- (void)doLoginAction {

    [self disableInteractions];
    
    
    //IF defaults.rememberMe is TRUE and swtRememberMe is FALSE then delete authenticated info
    
    
    if ([self isValidLoginAction]) {
        NSLog(@"Valid Login Action - call service here");
        
        loginServiceRequest = [[RailsServiceRequest alloc] init];
        loginServiceResponse = [[RailsServiceResponse alloc] init];
        
        /*
         * GET - Index
         */
        loginServiceRequest.requestActionCode = 0;
        loginServiceRequest.requestModel = RAILS_MODEL_USERS;
        loginServiceRequest.requestResponseNotificationName = RAILS_GET_INDEX_USERS_NOTIFICATION;
        
        /*
         * GET - Show (with an id parameter)
         */
//        loginServiceRequest.requestActionCode = 1;
//        loginServiceRequest.requestData = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [loginServiceRequest.requestData setValue:@"11" forKey:@"id"];
        
        /*
         * POST - Create
         */
//        loginServiceRequest.requestActionCode = 4;
//        loginServiceRequest.requestData = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [self.data setValue:@"foo@bar.com" forKey:@"email"];
//        [self.data setValue:@"foo@bar.com" forKey:@"username"];
//        [self.data setValue:@"foobar" forKey:@"password"];
//        [loginServiceRequest.requestData setValue:self.data forKey:@"user"];
        
        /*
         * PUT - Update
         */
//        loginServiceRequest.requestActionCode = 5;
//        loginServiceRequest.requestData = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [self.data setValue:@"iamupdated" forKey:@"first_name"];
//        [self.data setValue:@"foo@bar.com" forKey:@"username"];
//        [self.data setValue:@"foobar" forKey:@"password"];
//        [loginServiceRequest.requestData setValue:@"18" forKey:@"id"];
//        [loginServiceRequest.requestData setValue:self.data forKey:@"user"];
        
        /*
         * DELETE - Destroy
         */
//        loginServiceRequest.requestActionCode = 6;
//        loginServiceRequest.requestData = [[NSMutableDictionary alloc] initWithCapacity:1];
//        [loginServiceRequest.requestData setValue:@"18" forKey:@"id"];

        //TODO: when to dealloc/release request/response?
        
        YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([[delegate railsService] callServiceWithRequest:loginServiceRequest andResponsePointer:loginServiceResponse]) {
            NSLog(@"Called service");
        }
        else {
            NSLog(@"Call failed");
        }
        
        
        
        //[self.parentViewController dismissModalViewControllerAnimated:YES];
    }
    
    
    [self enableInteractions];
    
    [aivLogin stopAnimating];
}

- (void)getIndexResponseReceived {
    NSLog(@"Reponse was received");
    for (id item in loginServiceResponse.responseData) {
        NSLog(@"Item: %@", item);
    }
}

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __loginErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__loginErrorAlertView show];
    [__loginErrorAlertView release];
    
    return FALSE;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

- (BOOL)isValidLoginAction {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hasAuthenticated = [userDefaults objectForKey:@"hasAuthenticated"];
    NSString *hasEstablishedPin = [userDefaults objectForKey:@"hasEstablishedPin"];
    NSString *authenticatedPin = [userDefaults objectForKey:@"authenticatedPin"];
    
    if ([txfUsername.text isEqualToString:@""]) {
        NSLog(@"Username must not be blank");
        
        return [self alertViewForError:@"Username must not be blank" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if ([txfPassword.text isEqualToString:@""]) {
        NSLog(@"Password must not be blank");
        
        return [self alertViewForError:@"Password must not be blank" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    if ([hasAuthenticated isEqualToString:@"TRUE"]) {
        if([hasEstablishedPin isEqualToString:@"TRUE"]) {
            if ([txfPin.text isEqualToString:@""]) {
                NSLog(@"If a PIN has been established, it must not be blank");
                
                return [self alertViewForError:@"If a PIN has been established, it must not be blank" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            else if (![txfPin.text isEqualToString:authenticatedPin]) {
                NSLog(@"Entered PIN does not match authenticated PIN");
                
                return [self alertViewForError:@"Entered PIN does not match authenticated PIN" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
        }
    }
    
    return TRUE;
}

@end
