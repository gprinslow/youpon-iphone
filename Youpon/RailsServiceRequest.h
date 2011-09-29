//
//  RailsServiceRequest.h
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RailsServiceRequest : NSObject {
    int _requestActionCode;
    NSString *_requestModel;
    NSMutableDictionary *_requestData;
    NSString *_requestResponseNotificationName;
}

@property (nonatomic) int requestActionCode;
@property (nonatomic, retain) NSString *requestModel;
@property (nonatomic, retain) NSMutableDictionary *requestData;
@property (nonatomic, retain) NSString *requestResponseNotificationName;

@end
