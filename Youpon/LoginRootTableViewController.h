//
//  LoginRootTableViewController.h
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedEditTableViewController.h"

@interface LoginRootTableViewController : GroupedEditTableViewController {
    UITextField *txfUsername;
    UITextField *txfPassword;
    UITextField *txfPin;
}


- (IBAction)usernameEditingDidEndOnExit:(id)sender;
- (IBAction)passwordEditingDidEndOnExit:(id)sender;
- (IBAction)pinEditingDidEndOnExit:(id)sender;

- (IBAction)switchToRegistration;

@end
