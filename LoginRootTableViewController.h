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
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"
#import "TableRowDetailEditController.h"
#import "TextEntryTableViewCell.h"

#import "RailsService.h"
#import "RegistrationRootTableViewController.h"


@interface LoginRootTableViewController : GroupedEditTableViewController {
    UITextField *txfEmail;
    UITextField *txfPassword;
    UIButton *btnLogin;
    UIActivityIndicatorView *aivLogin;
    UISwitch *swtRememberMe;
    TextEntryTableViewCell *cellEmail;
    
    RegistrationRootTableViewController *_registrationRootTableViewController;
    
    //Added for service calls
    RailsServiceRequest *loginServiceRequest;
    RailsServiceResponse *loginServiceResponse;
}


@property (nonatomic, retain) IBOutlet RegistrationRootTableViewController *registrationRootTableViewController;

- (IBAction)emailEditingDidEndOnExit:(id)sender;
- (IBAction)passwordEditingDidEndOnExit:(id)sender;
- (IBAction)rememberMeSwitchValueChanged:(id)sender;
- (IBAction)textfieldValueChanged:(UITextField *)source;

- (IBAction)switchToRegistration;
- (IBAction)startLoginAction;
- (void)doLoginAction;
- (BOOL)isValidLoginAction;

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
