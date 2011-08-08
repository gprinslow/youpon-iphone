//
//  GroupedEditTableView.m
//  Youpon
//
//  Created by Garrison on 8/8/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "GroupedEditTableView.h"
#import "TextEntryTableViewCell.h"

@implementation GroupedEditTableView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	bool backgroundTouched = true;
	
	for (UITouch *touch in touches) {
		CGPoint location = [touch locationInView:self];
		for (UITableViewCell *cell in self.visibleCells) {
			if (CGRectContainsPoint(cell.frame, location)) {
				backgroundTouched = false;
				break;
			}
		}
	}
    
	if (backgroundTouched) {
		for (id cell in self.visibleCells) {
			// The first subview is the text field inside the cell
			//[[cell.contentView.subviews objectAtIndex:0] resignFirstResponder];
            
            if ([cell isKindOfClass:[TextEntryTableViewCell class]]) {
                TextEntryTableViewCell *tCell = (TextEntryTableViewCell *)cell;
                
                [tCell.textField resignFirstResponder];
            }
		}
	}
	
	[super touchesBegan:touches withEvent:event];
}

@end
