//
//  RegistrationRootTableViewController.h
//  Youpon
//
//  Created by Garrison on 8/11/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedEditTableViewController.h"

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
 

    
    
    @private
    NSArray *rowPlaceholders;
}

- (IBAction)startRegistrationAction;
- (void)doRegistrationAction;
- (BOOL)isValidRegistrationAction;
- (IBAction)cancelRegistration;

@end
