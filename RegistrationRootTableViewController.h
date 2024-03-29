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
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"
#import "TableRowDetailEditController.h"
#import "TextEntryTableViewCell.h"

#import "RailsService.h"

@interface RegistrationRootTableViewController : GroupedEditTableViewController {
    UITextField *txfEmail;
    UITextField *txfPassword;
    UITextField *txfPasswordConfirm;
    UISwitch *swtRememberMe;
    
    UITextField *txfName;
    
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
- (IBAction)textfieldValueChanged:(UITextField *)source;

- (IBAction)startRegistrationAction;
- (void)doRegistrationAction;
- (void)createUserResponseReceived;
- (BOOL)isValidRegistrationAction;
- (IBAction)cancelRegistration;

- (IBAction)startLoginAction;
- (void)doLoginAction;
- (void)createSessionResponseReceived;

- (void)updateRememberMeOrDeleteRememberedData;

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
