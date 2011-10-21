//
//  RegistrationRootTableViewController.h
//  Youpon
//
//  Created by Garrison on 8/11/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedEditTableViewController.h"
#import "GroupedEditTableView.h"
#import "RailsService.h"
#import "YouponAppDelegate.h"

@interface RegistrationRootTableViewController : GroupedEditTableViewController {
    UITextField *txfUsername;
    UITextField *txfPassword;
    UITextField *txfPasswordConfirm;
    UITextField *txfPin;
    UITextField *txfEmail;
    UISwitch *swtRememberMe;
    
    UITextField *txfNameFirst;
    UITextField *txfNameMiddle;
    UITextField *txfNameLast;
    
    UITextField *txfZipCode;
    
    UIButton *btnRegister;
    UIActivityIndicatorView *aivRegister;
 
    GroupedEditTableView *groupedEditTableView;
    
    //Added for service calls
    RailsServiceRequest *registerServiceRequest;
    RailsServiceResponse *registerServiceResponse;
    
    @private
    NSArray *rowPlaceholders;
}

- (IBAction)rememberMeSwitchValueChanged:(id)sender;

- (IBAction)startRegistrationAction;
- (void)doRegistrationAction;
- (BOOL)isValidRegistrationAction;
- (IBAction)cancelRegistration;

- (void)updateRememberMeOrDeleteRememberedData;
- (void)storeEnteredData;

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
