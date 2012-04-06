//
//  RailsServiceResponse.h
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RailsServiceResponse : NSObject {
    NSMutableDictionary *_responseData;
    NSString *_responseString;
    NSString *_responseCode;
    NSError *_responseError;
}

@property (nonatomic, retain) NSMutableDictionary *responseData;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSString *responseCode;
@property (nonatomic, retain) NSError *responseError;

@end
