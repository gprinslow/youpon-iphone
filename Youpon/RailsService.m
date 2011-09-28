//
//  RailsService.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsService.h"


/*
 * Private constants
 */

static NSString *const UNSECURE_SERVER_URL = @"http://0.0.0.0:3000/";
static NSString *const SECURE_SERVER_URL = @"https://0.0.0.0:3001/";
static NSString *const REQUEST_URL_EXTENSION = @".json";
static NSString *const REQUEST_HTTP_HEADER_FIELD = @"Content-Type";
static NSString *const REQUEST_HTTP_HEADER_FIELD_VALUE = @"application/json";
static NSString *const HTTP_GET = @"GET";
static NSString *const HTTP_POST = @"POST";
static NSString *const HTTP_PUT = @"PUT";
static NSString *const HTTP_DELETE = @"DELETE";

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

//*** end private constants


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
            self.requestServerURLString = [[NSString alloc] initWithString:SECURE_SERVER_URL];
        }
        else {
            self.requestServerURLString = [[NSString alloc] initWithString:UNSECURE_SERVER_URL];
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
    /*
     * This must be updated for each model supported
     * TODO: Evaluate use of public static strings instead...
     */
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
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_GET];
            break;
        case kActionGETshow:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_GET];
            break;
        case kActionPOSTcreate:
            action = [[NSString alloc] initWithString:@""];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_POST];
            break;
        case kActionPUTupdate:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_PUT];
            break;
        case kActionDELETEdestroy:
            action = [NSString stringWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_DELETE];
            break;
        default:
            break;
    }
    
    //Set Action URL String
    self.requestActionURLString = [NSString stringWithFormat:@"%@%@", model, action];
    
    //Set Full URL
    self.requestURLString = [NSString stringWithFormat:@"%@%@%@", [self requestServerURLString], [self requestActionURLString], REQUEST_URL_EXTENSION];
    self.requestURL = [NSURL URLWithString:[self requestURLString]];
    
    //Set Mutable URL Request
    self.requestMutableURLRequest = [NSMutableURLRequest requestWithURL:[self requestURL]];
    
    
    //Memory cleanup
    [model release];
    [action release];
    
    return railsServiceResponse;
}




@end
