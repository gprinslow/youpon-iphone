//
//  TableRowDetailEditDateController.h
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowDetailEditController.h"

@interface TableRowDetailEditDateController : TableRowDetailEditController {
    UIDatePicker *datePicker;
    UITableView *dateTableView;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;

-(IBAction)dateChanged;

@end
