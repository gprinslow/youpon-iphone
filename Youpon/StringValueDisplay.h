//
//  StringValueDisplay.h
//  Youpon
//
//  Created by Garrison on 8/4/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol StringValueDisplay
- (NSString *)stringValueDisplay;
@end

@interface NSString (StringValueDisplay) <StringValueDisplay>
- (NSString *)stringValueDisplay;
@end

@interface NSDate (StringValueDisplay) <StringValueDisplay>
- (NSString *)stringValueDisplay;
@end

@interface NSNumber (StringValueDisplay) <StringValueDisplay>
- (NSString *)stringValueDisplay;
@end

@interface NSDecimalNumber (StringValueDisplay) <StringValueDisplay>
- (NSString *)stringValueDisplay;
@end
