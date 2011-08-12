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

@interface LoginRootTableViewController : GroupedEditTableViewController {
    UITextField *txfUsername;
    UITextField *txfPassword;
    UITextField *txfPin;
    UIButton *btnLogin;
    UIActivityIndicatorView *aivLogin;
    UISwitch *swtRememberMe;
    TextEntryTableViewCell *cellUsername;
}


- (IBAction)usernameEditingDidEndOnExit:(id)sender;
- (IBAction)passwordEditingDidEndOnExit:(id)sender;
- (IBAction)pinEditingDidEndOnExit:(id)sender;
- (IBAction)rememberMeSwitchValueChanged:(id)sender;

- (IBAction)switchToRegistration;
- (IBAction)doLoginAction;
- (BOOL)isValidLoginAction;

@end
