//
//  LoginRootTableViewController.m
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "LoginRootTableViewController.h"
#import "YouponAppDelegate.h"

#define kEmailCellTag 1
#define kPasswordCellTag 2
#define kRememberMeCellTag 6

static NSString *const RAILS_CREATE_SESSION_NOTIFICATION = @"RAILS_CREATE_SESSION_NOTIFICATION";

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
    self.title = NSLocalizedString(@"Youpon - Sign in", @"Youpon - Sign in");
    
    UIBarButtonItem *registrationButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign up" style:UIBarButtonItemStylePlain target:self action:@selector(switchToRegistration)];
    
    self.navigationItem.rightBarButtonItem = registrationButtonItem;
    
    //-ADDED-
    data = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    sectionNames = [[NSArray alloc] initWithObjects:
                    [NSNull null], 
                    nil];
    
    rowLabels = [[NSArray alloc] initWithObjects:

                 //Section 1
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Email", @"Email"),
                  NSLocalizedString(@"Password", @"Password"),
                  NSLocalizedString(@"Remember Me", @"Remember Me"),
                  NSLocalizedString(@"", @"LoginButton"),
                  nil],

                 nil];
    
    rowKeys = [[NSArray alloc] initWithObjects:
               
               //Section 1
               [NSArray arrayWithObjects:
                @"email",
                @"password",
                @"rememberMe",
                @"loginButton",
                nil],
               
               nil];
    
    rowControllers = [[NSArray alloc] initWithObjects:
                 
                 //Section 1
                 [NSArray arrayWithObjects:
                  [NSNull null],
                  [NSNull null],
                  [NSNull null],
                  [NSNull null],
                  nil],
                 
                 nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                      
                      //Section 1
                    [NSArray arrayWithObjects:
                     [NSNull null], 
                     [NSNull null],
                     [NSNull null],
                     [NSNull null],
                     nil],
                      
                      nil];
    
    /*
     * Prepare data for LoginView
     * TODO: Improve security of stored email, password, pin (userDefaults unsecure)
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //IF rememberMe
    BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
    
    if (rememberMe) {
        //IF hasAuthenticated        
        BOOL hasAuthenticated = [userDefaults boolForKey:@"hasAuthenticated"];

        if (hasAuthenticated) {
            NSString *authenticatedEmail = [userDefaults objectForKey:@"authenticatedEmail"];
            
            [self.data setValue:authenticatedEmail forKey:@"email"];
        }
        else {
            [self.data setValue:@"" forKey:@"email"];
            [self.data setValue:@"" forKey:@"password"];
        }
    }
    else {
        [self.data setValue:@"" forKey:@"email"];
        [self.data setValue:@"" forKey:@"password"];
    }
    
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(createSessionResponseReceived) 
     name:RAILS_CREATE_SESSION_NOTIFICATION 
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

- (void)moveToFirstResponder {
    [txfEmail resignFirstResponder];
    [txfPassword resignFirstResponder];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
    
    if (rememberMe && ![txfEmail.text isEqualToString:@""]) {
        [txfPassword becomeFirstResponder];
    }
    else {
        [txfEmail becomeFirstResponder];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    static NSString *LoginRootTableViewControllerCellIdentifier = @"LoginRootTableViewControllerCellIdentifier";
    
    [self performSelector:@selector(moveToFirstResponder) withObject:nil afterDelay:0.2];
    
    if ([rowKey isEqualToString:@"email"]) {
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
        
        cell.textField.placeholder = @"Enter your email";
        
        cell.textField.text = [data valueForKey:rowKey];
        
        txfEmail = cell.textField;
        [txfEmail addTarget:self action:@selector(emailEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        //Added to get value to stay put
        txfEmail.tag = kEmailCellTag;
        [txfEmail addTarget:self action:@selector(textfieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        
        
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
        cell.textField.returnKeyType = UIReturnKeyNext;
        cell.textField.secureTextEntry = TRUE;
        
        cell.textField.placeholder = @"Enter your password";
        
        cell.textField.text = [data valueForKey:rowKey];
        
        txfPassword = cell.textField;
        [txfPassword addTarget:self action:@selector(passwordEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        //Added to get value to stay put
        txfPassword.tag = kPasswordCellTag;
        [txfPassword addTarget:self action:@selector(textfieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        
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
        BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
        
        cell.detailTextLabel.text = rowLabel;
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0];
        
        UISwitch *rememberMeSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0f, cellCenter, 24.0f, 24.0f)] autorelease];
        [rememberMeSwitch addTarget:self action:@selector(rememberMeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if (rememberMe) {
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
        
        if ([rowKey isEqualToString:@"email"]) {
            [txfEmail becomeFirstResponder];
        }
        else if ([rowKey isEqualToString:@"password"]) {
            [txfPassword becomeFirstResponder];
        }
        else if ([rowKey isEqualToString:@"loginButton"]) {
            [txfEmail resignFirstResponder];
            [txfPassword resignFirstResponder];
            
            if ([btnLogin isEnabled]) {
                [self startLoginAction];
            }
        }
        else if ([rowKey isEqualToString:@"rememberMe"]) {
            [txfEmail resignFirstResponder];
            [txfPassword resignFirstResponder];
            
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

- (IBAction)emailEditingDidEndOnExit:(id)sender {
    [self.data setValue:txfEmail.text forKey:@"email"];
    
    [sender resignFirstResponder];
    
    if (![txfEmail.text isEqualToString:@""] && ![txfPassword.text isEqualToString:@""]) {
        [self startLoginAction];
    }
    else {
        [txfPassword becomeFirstResponder];
    }
}
- (IBAction)passwordEditingDidEndOnExit:(id)sender {
    [self.data setValue:txfPassword.text forKey:@"password"];
    
    [sender resignFirstResponder];
    
    if (![txfEmail.text isEqualToString:@""] && ![txfPassword.text isEqualToString:@""]) {
        [self startLoginAction];
    }
    else {
        [txfEmail becomeFirstResponder];
    }
}

         
#pragma mark - Action methods for responding to value changed

- (IBAction)rememberMeSwitchValueChanged:(id)sender {
    if (![swtRememberMe isOn]) {
        //Turn OFF remember me (from ON): clear memory of authenticated info & clear 
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:FALSE forKey:@"rememberMe"];        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
        
        [txfEmail setText:@""];
    }
    //Else take no action
}

- (IBAction)textfieldValueChanged:(UITextField *)source {
    //This makes sure entered values are recorded when scrolling
    switch (source.tag) {
        case kEmailCellTag:
            [self.data setValue:source.text forKey:@"email"];
            break;
        case kPasswordCellTag:
            [self.data setValue:source.text forKey:@"password"];
            break;
        default:
            break;
    }
}

#pragma mark - Disable and Enable Interactions

- (void)disableInteractions {
    [btnLogin setEnabled:FALSE];
    [txfEmail setEnabled:FALSE];
    [txfPassword setEnabled:FALSE];
    
    [self.tableView setUserInteractionEnabled:FALSE];    
    [self.tableView setAllowsSelection:FALSE];
}

- (void)enableInteractions {
    [btnLogin setEnabled:TRUE];
    [txfEmail setEnabled:TRUE];
    [txfPassword setEnabled:TRUE];
    
    [self.tableView setUserInteractionEnabled:TRUE];
    [self.tableView setAllowsSelection:TRUE];
}


#pragma mark - Switch to Registration Screen

-(void)saveDataOnTransferToRegistration {
    [self.data setValue:txfEmail.text forKey:@"email"];
    [self.data setValue:txfPassword.text forKey:@"password"];
     
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
    
    //IF swtRememberMe isOn then save that and store the entered PIN for the registration screen
    if ([swtRememberMe isOn]) {
        [userDefaults setBool:TRUE forKey:@"rememberMe"];
    }
    //IF defaults.rememberMe is TRUE and swtRememberMe is FALSE then delete authenticated info
    else if (rememberMe && ![swtRememberMe isOn]) { 
        
        [userDefaults setBool:FALSE forKey:@"rememberMe"];        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
    }
}

- (IBAction)switchToRegistration {
    
    [self saveDataOnTransferToRegistration];
    
    _registrationRootTableViewController = [[RegistrationRootTableViewController alloc] initWithNibName:@"RegistrationRootTableViewController" bundle:nil];
    
    _registrationRootTableViewController.data = [[NSMutableDictionary alloc] initWithCapacity:15];
    
    [self.registrationRootTableViewController.data setValuesForKeysWithDictionary:self.data];
    
    [self.navigationController pushViewController:self.registrationRootTableViewController animated:YES];
}

#pragma mark - Login Action & Service Call & Handle Response

- (void)updateRememberMeOrDeleteRememberedData {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
    
    //IF swtRememberMe isOn then save that
    if ([swtRememberMe isOn]) {
        [userDefaults setBool:TRUE forKey:@"rememberMe"];
    }
    //IF defaults.rememberMe is TRUE and swtRememberMe is FALSE then delete authenticated info
    else if (rememberMe && ![swtRememberMe isOn]) {
        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        [userDefaults setBool:FALSE forKey:@"rememberMe"];
        
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
    }
}

- (IBAction)startLoginAction {
    [txfEmail resignFirstResponder];
    [txfPassword resignFirstResponder];
    
    [aivLogin startAnimating];
    
    [self performSelector:@selector(doLoginAction) withObject:nil afterDelay:0.5];
}

- (void)doLoginAction {

    [self disableInteractions];
    
    /*
     * Steps:   1) store user/pass in self.data
     *          2) call sessions with user/pass
     *          3)a: if failure, return alert message
     *          3)b: if success, do the following:
     *                  store authenticated user/pass (and pin, if rememberMe isOn)
     *                  store the currentUser in App Delegate
     */
    
    if ([self isValidLoginAction]) {
        NSLog(@"Valid Login Action - calling service");
        
        /*
         * Step:   1) store user/pass in self.data
         */
        [self updateRememberMeOrDeleteRememberedData];
        
        [self.data setValue:txfEmail.text forKey:@"email"];
        [self.data setValue:txfPassword.text forKey:@"password"];
        
        /*
         * Step:    2) call sessions with user/pass
         */
        loginServiceRequest = [[RailsServiceRequest alloc] init];
        loginServiceResponse = [[RailsServiceResponse alloc] init];
        
        loginServiceRequest.requestActionCode = 4;
        loginServiceRequest.requestModel = RAILS_MODEL_SESSIONS;
        loginServiceRequest.requestResponseNotificationName = RAILS_CREATE_SESSION_NOTIFICATION;
        [loginServiceRequest.requestData setValue:self.data forKey:@"session"];
        
        //Can now call rails service singleton - see "createSessionResponseReceived"
        YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([[delegate railsService] callServiceWithRequest:loginServiceRequest andResponsePointer:loginServiceResponse]) {
            NSLog(@"Called CreateSession");
        }
        else {
            NSLog(@"Call to CreateSession Failed");
        }
    }
    else {
        NSLog(@"Failed login validation");
        [self enableInteractions];
        [aivLogin stopAnimating];
    }
}

/*
 * Response was received from service -- do actions/transitions depending on result
 */
- (void)createSessionResponseReceived {
    NSLog(@"CreateSession-ResponseReceived");
    

    /*  Steps:  3)a: if failure, return alert message
     *          3)b: if success, do the following:
     *                  IF rememberMe isOn: store authenticated user/pass (and pin if not blank)
     *                  store the currentUser in App Delegate
     *                  verify Delegate has non-nil Token
     */
    for (id item in loginServiceResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    //*  Step:  3)a: if failure, return alert message
    if ([loginServiceResponse.responseData objectForKey:@"errors"]) {
        
        NSString *errorMessage = (NSString *)[[[loginServiceResponse responseData] objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
         
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
        
        txfPassword.text = @"";
        
        [self alertViewForError:errorMessage title:@"Login Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self enableInteractions];
        
        [aivLogin stopAnimating];
    }
    //*          3)b: if success, do the following:
    else {
        /* IF rememberMe isOn: store authenticated user email
         */                  
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
        
        if (rememberMe) {            
            [userDefaults setBool:TRUE forKey:@"hasAuthenticated"];
            [userDefaults setValue:[self.data objectForKey:@"email"] forKey:@"authenticatedEmail"];
            
        }
        
        //* verify Delegate has non-nil Token
        YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (delegate.sessionToken != nil) {
            
            //* store the currentUser in App Delegate
            
            delegate.currentUser = [[NSDictionary alloc] 
                                    initWithDictionary:[loginServiceResponse.responseData objectForKey:@"items"] copyItems:TRUE];
            
            NSLog(@"Fully successful login");
            
            [self enableInteractions];
            
            [aivLogin stopAnimating];
            
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }
        else {
            //Some kind of error occurred, can't proceed
            NSLog(@"Login Error: session token is nil");
            
            [self enableInteractions];
            
            [aivLogin stopAnimating];
            
            [self alertViewForError:@"Session token was not received" title:@"Login Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
}


#pragma mark - Validation & Error Alerts

/*
 * Alert View for Errors
 */
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __loginErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__loginErrorAlertView show];
    [__loginErrorAlertView release];
    
    return FALSE;
}


/*
 * Validation
 */
- (BOOL)isValidLoginAction {

    if ([txfEmail.text isEqualToString:@""]) {
        NSLog(@"Email must not be blank");
        
        return [self alertViewForError:@"Email must not be blank" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if ([txfPassword.text isEqualToString:@""]) {
        NSLog(@"Password must not be blank");
        
        return [self alertViewForError:@"Password must not be blank" title:@"Validation Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    return TRUE;
}

@end
