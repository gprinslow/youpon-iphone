//
//  RailsServiceResponse.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsServiceResponse.h"

@implementation RailsServiceResponse

@synthesize responseData=_responseData;
@synthesize responseString=_responseString;
@synthesize responseCode=_responseCode;
@synthesize responseError=_responseError;


- (id)init {
    self = [super init];
    if (self) {
        if (![self responseData]) {
            self.responseData = [[NSMutableDictionary alloc] init];
        }
        if (![self responseString]) {
            self.responseString = [[NSString alloc] init];
        }
        if (![self responseCode]) {
            self.responseCode = [[NSString alloc] init];
        }
        if (![self responseError]) {
            self.responseError = nil;
        }
    }
    return self;
}

- (void)dealloc {
    [_responseData release];
    [_responseString release];
    [_responseCode release];
    [_responseError release];
}

@end
