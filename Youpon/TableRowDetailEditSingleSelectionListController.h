//
//  TableRowDetailEditSingleSelectionListController.h
//  Youpon
//
//  Created by Garrison on 8/5/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRowDetailEditController.h"

@interface TableRowDetailEditSingleSelectionListController : TableRowDetailEditController {
    NSArray *list;
    
    @private
    NSIndexPath *lastIndexPath;
    NSString *pendingValue;
}

@property (nonatomic, retain) NSArray *list;

@end
