//
//  GroupedEditTableViewController.h
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupedEditTableViewController : UITableViewController {
    NSMutableDictionary *data;
    
    @protected
    NSArray *sectionNames;
    NSArray *rowLabels;
    NSArray *rowKeys;
    NSArray *rowControllers;
    NSArray *rowArguments;
}

@property (nonatomic, retain) NSMutableDictionary *data;

@end
