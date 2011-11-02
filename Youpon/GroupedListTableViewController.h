//
//  GroupedListTableViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 11/2/11.
//  Copyright (c) 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"

@interface GroupedListTableViewController : UITableViewController {
    NSMutableDictionary *data;
    
    @protected
    NSArray *sectionHeaders;
    NSArray *sectionFooters;
    NSArray *rowLabels;
    NSArray *rowKeys;
    NSArray *rowControllers;
    NSArray *rowArguments;
}

@property (nonatomic, retain) NSMutableDictionary *data;


@end
