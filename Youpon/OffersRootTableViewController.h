//
//  OffersRootTableViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 11/2/11.
//  Copyright (c) 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedListTableViewController.h"
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"

@interface OffersRootTableViewController : GroupedListTableViewController <UIAlertViewDelegate>

-(void)remoteOffersRetrieved;
-(void)refreshResults;
-(void)doSignOut;

@end
