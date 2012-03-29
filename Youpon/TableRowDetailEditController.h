//
//  TableRowDetailEditController.h
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNonEditableTextColor [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0]

@interface TableRowDetailEditController : UITableViewController {
    NSMutableDictionary *data;
    NSString *keyPath;
    NSString *rowLabel;
}

@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, retain) NSString *rowLabel;

-(IBAction)cancel;
-(IBAction)saveEditedDataLocally;

@end
