//
//  LoginRootTableViewController.h
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedEditTableViewController.h"
#import "TextEntryTableViewCell.h"
#import "RegistrationRootTableViewController.h"
#import "RailsServiceRequest.h"
#import "RailsServiceResponse.h"

@interface LoginRootTableViewController : GroupedEditTableViewController {
    UITextField *txfUsername;
    UITextField *txfPassword;
    UITextField *txfPin;
    UIButton *btnLogin;
    UIActivityIndicatorView *aivLogin;
    UISwitch *swtRememberMe;
    TextEntryTableViewCell *cellUsername;
    
    RegistrationRootTableViewController *_registrationRootTableViewController;
    
    //Added for service calls
    RailsServiceRequest *loginServiceRequest;
    RailsServiceResponse *loginServiceResponse;
}


@property (nonatomic, retain) IBOutlet RegistrationRootTableViewController *registrationRootTableViewController;

- (IBAction)usernameEditingDidEndOnExit:(id)sender;
- (IBAction)passwordEditingDidEndOnExit:(id)sender;
- (IBAction)pinEditingDidEndOnExit:(id)sender;
- (IBAction)rememberMeSwitchValueChanged:(id)sender;

- (IBAction)switchToRegistration;
- (IBAction)startLoginAction;
- (void)doLoginAction;
- (BOOL)isValidLoginAction;

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
