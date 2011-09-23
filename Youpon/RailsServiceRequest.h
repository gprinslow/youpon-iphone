//
//  RailsServiceRequest.h
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RailsServiceRequest : NSObject {
    NSString *_requestModel;
    NSString *_requestAction;
    NSMutableDictionary *_requestData;
    NSString *_requestResponseNotificationName;
}

@property (nonatomic, retain) NSString *requestModel;
@property (nonatomic, retain) NSString *requestAction;
@property (nonatomic, retain) NSMutableDictionary *requestData;
@property (nonatomic, retain) NSString *requestResponseNotificationName;

@end
