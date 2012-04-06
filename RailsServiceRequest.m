//
//  RailsServiceRequest.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsServiceRequest.h"


@implementation RailsServiceRequest

@synthesize requestActionCode=_requestActionCode;
@synthesize requestModel=_requestModel;
@synthesize requestData=_requestData;
@synthesize requestResponseNotificationName=_requestResponseNotificationName;

- (id)init {
    self = [super init];
    if (self) {
        if (![self requestModel]) {
            self.requestModel = [[NSString alloc] init];
        }
        if (![self requestData]) {
            self.requestData = [[NSMutableDictionary alloc] init];
        }
        if (![self requestResponseNotificationName]) {
            self.requestResponseNotificationName = [[NSString alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [_requestModel release];
    [_requestData release];
    [_requestResponseNotificationName release];
    
    [super dealloc];
}


@end
