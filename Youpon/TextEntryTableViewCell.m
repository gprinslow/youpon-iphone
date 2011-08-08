//
//  TextEntryTableViewCell.m
//  Youpon
//
//  Created by Garrison on 8/8/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "TextEntryTableViewCell.h"


@implementation TextEntryTableViewCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryNone;
        
        
        //X-Coord of origin point
        CGFloat x = 100;
        //Y-Coord of origin point
        CGFloat y = 9;
        //Width of rectangle
        CGFloat width = (self.frame.size.width - x - self.indentationWidth);
        //Height of rectangle
        CGFloat height = 24;
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.textField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        self.textField.autoresizesSubviews=TRUE;
        [self.textField setBorderStyle:UITextBorderStyleNone];

        
        [self addSubview:self.textField];                  
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_textField release];
    [super dealloc];
}

@end
