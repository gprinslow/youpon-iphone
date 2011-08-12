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
    
    @private
    NSArray *rowPlaceholderText;
}

- (IBAction)startRegistrationAction;
- (void)doRegistrationAction;
- (BOOL)isValidRegistrationAction;
- (IBAction)cancelRegistration;

@end
