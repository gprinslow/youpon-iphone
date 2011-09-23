//
//  RailsServiceRequest.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsServiceRequest.h"


@implementation RailsServiceRequest

@synthesize requestModel=_requestModel;
@synthesize requestAction=_requestAction;
@synthesize requestData=_requestData;
@synthesize requestResponseNotificationName=_requestResponseNotificationName;

- (id)init {
    self = [super init];
    if (self) {
        if (![self requestModel]) {
            self.requestModel = [[NSString alloc] init];
        }
        if (![self requestAction]) {
            self.requestAction = [[NSString alloc] init];
        }
        if (![self requestData]) {
            self.requestData = [[NSMutableDictionary alloc] init];
        }
        if (![self requestResponseNotificationName]) {
            self.requestResponseNotificationName = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [_requestModel release];
    [_requestAction release];
    [_requestData release];
    [_requestResponseNotificationName release];
}


@end
