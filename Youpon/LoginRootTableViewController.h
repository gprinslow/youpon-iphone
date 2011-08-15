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

@interface LoginRootTableViewController : GroupedEditTableViewController {
    UITextField *txfUsername;
    UITextField *txfPassword;
    UITextField *txfPin;
    UIButton *btnLogin;
    UIActivityIndicatorView *aivLogin;
    UISwitch *swtRememberMe;
    TextEntryTableViewCell *cellUsername;
    
    RegistrationRootTableViewController *_registrationRootTableViewController;
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

@end
