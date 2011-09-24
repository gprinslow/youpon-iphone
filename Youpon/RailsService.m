//
//  RailsService.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsService.h"

#define kUnsecureServerURL "http://0.0.0.0:3000/"
#define kSecureServerURL "https://0.0.0.0:3001/"
#define kUseSecureServerURL 1       //1 = true, 0 = false

//Models
#define kUsersModel 0
#define kOffersModel 1

//Actions
#define kActionGETindex 0
#define kActionGETshow 1
//#define kActionGETnew 2     //Not used
//#define kActionGETedit 3   //Not used
#define kActionPOSTcreate 4
#define kActionPUTupdate 5
#define kActionDELETEdestroy 6


@implementation RailsService


//Properties - Ideally, should be private
@synthesize requestServerURLString=_requestServerURLString;
@synthesize requestActionURLString=_requestActionURLString;
@synthesize requestURLString=_requestURLString;
@synthesize requestURL=_requestURL;
@synthesize requestMutableURLRequest=_requestMutableURLRequest;
@synthesize requestURLConnection=_requestURLConnection;
@synthesize requestHTTPMethod=_requestHTTPMethod;
@synthesize requestHTTPHeaderField=_requestHTTPHeaderField;
@synthesize requestHTTPHeaderFieldValue=_requestHTTPHeaderFieldValue;

@synthesize requestJSONData=_requestJSONData;

@synthesize responseData=_responseData;



- (id)init {
    self = [super init];
    if (self) {
        if (kUseSecureServerURL == 1) {
            self.requestServerURLString = [[NSString alloc] initWithCString:kSecureServerURL encoding:NSUTF8StringEncoding];
        }
        else {
            self.requestServerURLString = [[NSString alloc] initWithCString:kUnsecureServerURL encoding:NSUTF8StringEncoding];
        }
    }
    return self;
}

- (void)dealloc {

    
    [_requestServerURLString release];
    [_requestActionURLString release];
    [_requestURLString release];
    [_requestURL release];
    [_requestMutableURLRequest release];
    [_requestURLConnection release];
    [_requestHTTPMethod release];
    [_requestHTTPHeaderField release];
    [_requestHTTPHeaderFieldValue release];
    
    [_requestJSONData release];
    
    [_responseData release];
    
    [super dealloc];
}


- (RailsServiceResponse *)callServiceWithRequest:(RailsServiceRequest *)railsServiceRequest {
    
    RailsServiceResponse *railsServiceResponse = [[[RailsServiceResponse alloc] init] autorelease];
    
    NSString *model;
    NSString *action;

    //Parse Model
    switch (railsServiceRequest.requestModelCode) {
        case kUsersModel:
            model = [[NSString alloc] initWithString:@"users"];
            break;
        case kOffersModel:
            model = [[NSString alloc] initWithString:@"offers"];
            break;
        default:
            break;
    }
    
    //Parse Action --> variables --> private method   
    switch (railsServiceRequest.requestActionCode) {
        case kActionGETindex:
            action = [[NSString alloc] initWithString:@""];
            self.requestHTTPMethod = [[NSString alloc] initWithString:@"GET"];
            break;
        case kActionGETshow:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:@"GET"];
            break;
        case kActionPOSTcreate:
            action = [[NSString alloc] initWithString:@""];
            self.requestHTTPMethod = [[NSString alloc] initWithString:@"POST"];
            break;
        case kActionPUTupdate:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:@"PUT"];
            break;
        case kActionDELETEdestroy:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:@"DELETE"];
            break;
        default:
            break;
    }
    
    //Set Action URL String
    self.requestActionURLString = [NSString stringWithFormat:@"%@%@", model, action];
    
    //Set Full URL
    self.requestURL = [NSString stringWithFormat:@"%@%@", [self requestServerURLString], [self requestActionURLString]];
    
    //Set Mutable URL Request

    
    //Memory cleanup
    [model release];
    [action release];
    
    return railsServiceResponse;
}




@end
