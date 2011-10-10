//
//  RailsService.h
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "RailsServiceRequest.h"
#import "RailsServiceResponse.h"

//TODO: Refactor with private ivars and methods...

/*
 * Rails Models
 */
extern NSString *const RAILS_MODEL_USERS;
extern NSString *const RAILS_MODEL_OFFERS;
extern NSString *const RAILS_MODEL_SESSIONS;


@interface RailsService : NSObject {

    //Ideally, these should all be private
    NSString *_requestServerURLString;
    NSString *_requestActionURLString;
    NSString *_requestURLString;
    NSURL *_requestURL;
    NSMutableURLRequest *_requestMutableURLRequest;
    NSURLConnection *_requestURLConnection;
    NSString *_requestHTTPMethod;
    NSString *_requestHTTPHeaderField;
    NSString *_requestHTTPHeaderFieldValue;
    
    NSData *_requestJSONData;
    
    NSMutableData *_responseData;
    
    @private
    RailsServiceResponse *__railsServiceResponse;   //Note: This is just a pointer; must be alloc'd by caller
    RailsServiceRequest *__railsServiceRequest;
}



@property (nonatomic, retain) NSString *requestServerURLString;
@property (nonatomic, retain) NSString *requestActionURLString;
@property (nonatomic, retain) NSString *requestURLString;
@property (nonatomic, retain) NSURL *requestURL;
@property (nonatomic, retain) NSMutableURLRequest *requestMutableURLRequest;

@property (nonatomic, retain) NSURLConnection *requestURLConnection;
@property (nonatomic, retain) NSString *requestHTTPMethod;
@property (nonatomic, retain) NSString *requestHTTPHeaderField;
@property (nonatomic, retain) NSString *requestHTTPHeaderFieldValue;

@property (nonatomic, retain) NSData *requestJSONData;

@property (nonatomic, retain) NSMutableData *responseData;

- (BOOL)callServiceWithRequest:(RailsServiceRequest *)railsServiceRequest andResponsePointer:(RailsServiceResponse *)remoteRailsServiceResponse;

//THESE SHOULD BE PRIVATE
- (BOOL)sendRailsServiceRequest:(RailsServiceRequest *)railsServiceRequest mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest;

- (BOOL)sendRailsServiceRequest:(RailsServiceRequest *)railsServiceRequest mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest requestHTTPParameters:(NSString *)requestHTTPParameters;


@end
