//
//  RegistrationRootTableViewController.m
//  Youpon
//
//  Created by Garrison on 8/11/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RegistrationRootTableViewController.h"
#import "YouponAppDelegate.h"

#define kEmailCellTag 1
#define kPasswordCellTag 2
#define kPasswordConfirmCellTag 3
#define kRememberMeCellTag 6

#define kNameCellTag 7

#define kBirthdayCellTag 11
#define kGenderCellTag 12

#define kRegisterButtonCellTag 14

UIAlertView *__registrationErrorAlertView;

static NSString *const RAILS_CREATE_USER_NOTIFICATION = @"RAILS_CREATE_USER_NOTIFICATION";
static NSString *const RAILS_CREATE_SESSION_NOTIFICATION = @"RAILS_CREATE_SESSION_NOTIFICATION";


@implementation RegistrationRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Custom initialization
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
    
    self.title = NSLocalizedString(@"Sign up", @"Sign up");
    
    UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRegistration)] autorelease];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    //This reference facilitates resigning first responders
    groupedEditTableView = (GroupedEditTableView *)self.tableView;
    
    //Note: data does not need to be initialized, this is done in the Login class
    
    sectionNames = [[NSArray alloc] initWithObjects:
                    NSLocalizedString(@"Login Info", "Login Info"),
                    NSLocalizedString(@"Name", @"Name"),
                    NSLocalizedString(@"Demographics", @"Demographics"),
                    [NSNull null],
                    nil];
    
    rowLabels = [[NSArray alloc] initWithObjects:
                 
                 //Section 1 - Login (4)
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Email*", @"Email*"),
                  NSLocalizedString(@"Password*", @"Password*"),
                  NSLocalizedString(@"Confirm*", @"Confirm*"),
                  NSLocalizedString(@"Remember Me*", @"Remember Me*"),
                  nil],
                 
                 //Section 2 - Name
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Name*", @"Name*"),
                  nil],
                 
                 //Section 3 - Demographics
                 [NSArray arrayWithObjects:
                  NSLocalizedString(@"Birthday", @"Birthday"),
                  NSLocalizedString(@"Gender", @"Gender"),
                  nil],
                    
                 //Section 4 - Registration Button
                 [NSArray arrayWithObjects:
                  [NSNull null],
                  nil],
                 
                 nil];
    
    rowKeys = [[NSArray alloc] initWithObjects:
                 
                 //Section 1 - Login
                 [NSArray arrayWithObjects:
                  @"email",
                  @"password",
                  @"password_confirmation",
                  @"rememberMe",
                  nil],
                 
                 //Section 2 - Name
                 [NSArray arrayWithObjects:
                  @"name",
                  nil],
                 
                 //Section 3 - Demographics
                 [NSArray arrayWithObjects:
                  @"birthday",
                  @"gender",
                  nil],
                 
                 //Section 4 - Registration Button
                 [NSArray arrayWithObjects:
                  @"registerButton",
                  nil],
                 
                 nil];
    
    rowPlaceholders = [[NSArray alloc] initWithObjects:
                
                          //Section 1 - Login
                          [NSArray arrayWithObjects:
                           @"Enter an email",
                           @"Enter a password",
                           @"Confirm password",
                           @"Remember your email",
                           nil],
                          
                          //Section 2 - Name
                          [NSArray arrayWithObjects:
                           @"Enter your name",
                           nil],
                          
                          //Section 3 - Demographics
                          [NSArray arrayWithObjects:
                           @"Enter your birthday",
                           @"Select your gender",
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
                @"SwitchTableViewCell",
                nil],
               
               //Section 2 - Name
               [NSArray arrayWithObjects:
                @"TextEntryTableViewCell",
                nil],
               
               //Section 3 - Demographics
               [NSArray arrayWithObjects:
                @"TableRowDetailEditDateController",
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
                       nil],
                      
                      //Section 2 - Name
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       nil],
                      
                      //Section 3 - Demographics
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"Female", @"Male", @"Unspecified", nil] forKey:@"list"],
                       nil],
                      
                      //Section 4 - Registration Button
                      [NSArray arrayWithObjects:
                       [NSNull null],
                       nil],
                      
                      nil];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(createUserResponseReceived) 
     name:RAILS_CREATE_USER_NOTIFICATION 
     object:nil];
    
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
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textField.placeholder = [rowPlaceholders nestedObjectAtIndexPath:indexPath];
            cell.textField.text = [data valueForKey:rowKey];
                 
            if ([rowKey isEqualToString:@"email"]) {
                cell.tag = kEmailCellTag;
                txfEmail = cell.textField;
            }
            else if ([rowKey isEqualToString:@"password"]){
                cell.tag = kPasswordCellTag;
                txfPassword = cell.textField;
                txfPassword.secureTextEntry = TRUE;
            }
            else if ([rowKey isEqualToString:@"password_confirmation"]) {
                cell.tag = kPasswordConfirmCellTag;
                txfPasswordConfirm = cell.textField;
                txfPasswordConfirm.secureTextEntry = TRUE;
            }
            else if ([rowKey isEqualToString:@"name"]) {
                cell.tag = kNameCellTag;
                txfName = cell.textField;
            }

            
            //This keeps the value of the edited textfield for re-display
            cell.textField.tag = cell.tag;
            [cell.textField addTarget:self action:@selector(textfieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];

            
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
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                BOOL rememberMe = [userDefaults boolForKey:@"rememberMe"];
                
                if (rememberMe) {
                    [swtRememberMe setOn:TRUE animated:FALSE];
                }
                else {
                    [swtRememberMe setOn:FALSE animated:FALSE];
                }
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
                [registerButton setTitle:@"Sign up" forState:UIControlStateNormal];
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
        }
        else {
            [swtRememberMe setOn:!swtRememberMe.on animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)disableInteractions {
    [groupedEditTableView setUserInteractionEnabled:FALSE];
    [groupedEditTableView setAllowsSelection:FALSE];
}

- (void)enableInteractions {
    [groupedEditTableView setUserInteractionEnabled:TRUE];
    [groupedEditTableView setAllowsSelection:TRUE];
}

- (IBAction)cancelRegistration {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rememberMeSwitchValueChanged:(id)sender {
    if (![swtRememberMe isOn]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:FALSE forKey:@"rememberMe"];        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
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
        case kPasswordConfirmCellTag:
            [self.data setValue:source.text forKey:@"password_confirmation"];
            break;
        case kNameCellTag:
            [self.data setValue:source.text forKey:@"name"];
            break;
        default:
            break;
    }
}

#pragma mark - Registration Action & Call

- (IBAction)startRegistrationAction {
    
    [groupedEditTableView resignAllFirstResponders];
    
    [aivRegister startAnimating];
    
    [self performSelector:@selector(doRegistrationAction) withObject:nil afterDelay:0.5];
}

- (void)doRegistrationAction {
    
    [self disableInteractions];
    
    if ([self isValidRegistrationAction]) {
        NSLog(@"Valid Registration Action - calling service");
        
        /*
         * Step:    1) store entered data in self.data
         */
        [self updateRememberMeOrDeleteRememberedData];
        //[self storeEnteredData];  Apparently this is no longer needed?
        
        /*
         * Step:    2) call registration with self.data
         */
        
        registerServiceRequest = [[RailsServiceRequest alloc] init];
        registerServiceResponse = [[RailsServiceResponse alloc] init];
        
        registerServiceRequest.requestActionCode = 4; //POST
        registerServiceRequest.requestModel = RAILS_MODEL_USERS;
        registerServiceRequest.requestResponseNotificationName = RAILS_CREATE_USER_NOTIFICATION;
        //Hack the Birthday-Date to String for now
        NSString *dateString = [NSString stringWithFormat:@"%@", [data valueForKey:@"birthday"]];
        [data setValue:dateString forKey:@"birthday"];
        
        [registerServiceRequest.requestData setValue:data forKey:@"user"];
        
        //Call rails service singleton - see "...ResponseReceived" method
        YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([[delegate railsService] callServiceWithRequest:registerServiceRequest andResponsePointer:registerServiceResponse]) {
            NSLog(@"Called service - Register");
        }
        else {
            NSLog(@"Call failed - Register");
        }        
    }
    else {
        NSLog(@"Failed validation");
        [self enableInteractions];
        [aivRegister stopAnimating];
    }
}

- (void)createUserResponseReceived {
    NSLog(@"Response was received");
    
    /*  Steps:  3)a: if failure, return alert message
     *          3)b: if success, do the following:
     *                  IF rememberMe isOn: store authenticated user/pass (and pin if not blank)
     *                  store the currentUser in App Delegate
     *                  verify Delegate has non-nil Token
     */
    for (id item in registerServiceResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    //*  Step:  3)a: if failure, return alert message
    if ([registerServiceResponse.responseData objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[registerServiceResponse.responseData objectForKey:@"errors"];
        
        NSLog(@"Error Response: %@", errorMessage);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:FALSE forKey:@"hasAuthenticated"];
        [userDefaults setValue:@"" forKey:@"authenticatedEmail"];
        
        txfPassword.text = @"";
        txfPasswordConfirm.text = @"";
        
        [self alertViewForError:errorMessage title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self enableInteractions];
        [aivRegister stopAnimating];
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
     
        /*
         * User created, call login (create session) to establish token & current user
         */
        [self doLoginAction];
    }
}

#pragma mark - Login (Session create call) methods

- (IBAction)startLoginAction {
    
    [groupedEditTableView resignAllFirstResponders];
    
    [self performSelector:@selector(doLoginAction) withObject:nil afterDelay:0.5];
}

- (void)doLoginAction {
    
    registerServiceRequest.requestActionCode = 4;
    registerServiceRequest.requestModel = RAILS_MODEL_SESSIONS;
    registerServiceRequest.requestResponseNotificationName = RAILS_CREATE_SESSION_NOTIFICATION;
    [registerServiceRequest.requestData setValue:self.data forKey:@"session"];
    
    
    //Can now call rails service singleton - see "createSessionResponseReceived"
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[delegate railsService] callServiceWithRequest:registerServiceRequest andResponsePointer:registerServiceResponse]) {
        NSLog(@"Called service - Login");
    }
    else {
        NSLog(@"Call failed - Login");
    }
}

- (void)createSessionResponseReceived {
    
    NSLog(@"Reponse was received - Session");
    
    for (id item in registerServiceResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    
    //* verify Delegate has non-nil Token
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //*  Step:  3)a: if failure, return alert message
    if ([registerServiceResponse.responseData objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[[registerServiceResponse responseData] objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
        
        [self alertViewForError:errorMessage title:@"Login Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self enableInteractions];
        
        [aivRegister stopAnimating];
    }
    else {
        if (delegate.sessionToken != nil) {
            
            //* store the currentUser in App Delegate
            
            delegate.currentUser = [[NSDictionary alloc] 
                                    initWithDictionary:[registerServiceResponse.responseData objectForKey:@"items"] copyItems:TRUE];
            
            NSLog(@"Fully successful registration");
            
            [self enableInteractions];
            
            [aivRegister stopAnimating];
            
            //FULLY DONE --> Go to main menu
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }
        else {
            //Some kind of error occurred, can't proceed
            NSLog(@"Login Error: session token is nil");
            
            [self enableInteractions];
            
            [aivRegister stopAnimating];
            
            [self alertViewForError:@"Could not create session" title:@"Login Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
}



#pragma mark - Registration helper methods

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


#pragma mark - Validation & Error Alerts

/*
 * Alert View for Errors
 */
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    [self enableInteractions];
    
    [aivRegister stopAnimating];
    
    __registrationErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__registrationErrorAlertView show];
    [__registrationErrorAlertView release];
    
    return FALSE;
}

/*
 * Some client-side validation
 */
- (BOOL)isValidRegistrationAction {
    if ([txfEmail.text isEqualToString:@""]) {
        return [self alertViewForError:@"Email cannot be blank" title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if ([txfPassword.text isEqualToString:@""]) {
        return [self alertViewForError:@"Password cannot be blank" title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if ([txfPasswordConfirm.text isEqualToString:@""]) {
        return [self alertViewForError:@"Password Confirmation cannot be blank" title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if ([txfName.text isEqualToString:@""]) {
        return [self alertViewForError:@"Name cannot be blank" title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    if (![txfPassword.text isEqualToString:txfPasswordConfirm.text]) {
        return [self alertViewForError:@"Password and Confirmation must match" title:@"Registration Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    return TRUE;
}



@end
