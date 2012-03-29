//
//  TextEntryTableViewCell.h
//  Youpon
//
//  Created by Garrison on 8/8/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextEntryTableViewCell : UITableViewCell {
    UITextField *_textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
