//
//  StringValueDisplay.m
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "StringValueDisplay.h"


@implementation NSString (StringValueDisplay)
- (NSString *)stringValueDisplay {
    return self;
}
@end

@implementation NSDate (StringValueDisplay)
- (NSString *)stringValueDisplay {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *returnString = [formatter stringFromDate:self];
    [formatter release];
    return returnString;
}
@end

@implementation NSNumber (StringValueDisplay)
- (NSString *)stringValueDisplay {
    return [self descriptionWithLocale:[NSLocale currentLocale]];
}
@end

@implementation NSDecimalNumber (StringValueDisplay)
- (NSString *)stringValueDisplay {
    return [self descriptionWithLocale:[NSLocale currentLocale]];
}
@end
