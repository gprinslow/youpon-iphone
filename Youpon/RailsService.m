//
//  RailsService.m
//  Youpon
//
//  Created by Garrison on 9/23/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "RailsService.h"
#import "YouponAppDelegate.h"

/*
 * Public Constants
 */

NSString *const RAILS_MODEL_USERS = @"users";
NSString *const RAILS_MODEL_OFFERS = @"offers";
NSString *const RAILS_MODEL_SESSIONS = @"sessions";

/*
 * Private constants
 */

static NSString *const UNSECURE_SERVER_URL = @"http://0.0.0.0:3000/";
static NSString *const SECURE_SERVER_URL = @"https://0.0.0.0:3001/";
static NSString *const REQUEST_URL_EXTENSION = @".json";
static NSString *const REQUEST_HTTP_HEADER_FIELD = @"Content-Type";
static NSString *const REQUEST_HTTP_HEADER_FIELD_LENGTH = @"Content-Length";
static NSString *const REQUEST_HTTP_HEADER_FIELD_VALUE = @"application/json";
static NSString *const HTTP_GET = @"GET";
static NSString *const HTTP_POST = @"POST";
static NSString *const HTTP_PUT = @"PUT";
static NSString *const HTTP_DELETE = @"DELETE";

#define kUseSecureServerURL 1       //1 = true, 0 = false

//Models
#define kUsersModel 0
#define kOffersModel 1
#define kSessionsModel 2

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

#pragma mark - Publicly Accessible Service Call

/**
 * Publicly accessible service call
 * Return : BOOL : Can only tell you that the URL connection was made (response asynchronous)
 */
- (BOOL)callServiceWithRequest:(RailsServiceRequest *)railsServiceRequest andResponsePointer:(RailsServiceResponse *)remoteRailsServiceResponse {
    
    /*
     * Retain pointer to the remoteRailsServiceResponse
     * NOTE: This is not allocated or initialized here...
     */
    __railsServiceResponse = remoteRailsServiceResponse;
    __railsServiceRequest = railsServiceRequest;
    
    NSString *action = @"";
    
    /*
     * Parse the Action parameter for the URL...
     * ...and establish HTTP Method
     */
    switch (railsServiceRequest.requestActionCode) {
        case kActionGETindex:
            action = [[NSString alloc] initWithString:@""];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_GET];
            break;
        case kActionGETshow:
            action = [[NSString alloc] initWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_GET];
            break;
        case kActionPOSTcreate:
            action = [[NSString alloc] initWithString:@""];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_POST];
            break;
        case kActionPUTupdate:
            action = [[NSString alloc] initWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_PUT];
            break;
        case kActionDELETEdestroy:
            action = [[NSString alloc] initWithFormat:@"/%@", [[railsServiceRequest requestData] objectForKey:@"id"]];
            self.requestHTTPMethod = [[NSString alloc] initWithString:HTTP_DELETE];
            break;
        default:
            break;
    }
    
    /*
     * URL and MutableURL Request
     */
    //Set Action URL String
    self.requestActionURLString = [NSString stringWithFormat:@"%@%@", [railsServiceRequest requestModel], action];
    
    //Set Full URL
    self.requestURLString = [NSString stringWithFormat:@"%@%@%@", [self requestServerURLString], [self requestActionURLString], REQUEST_URL_EXTENSION];
    self.requestURL = [NSURL URLWithString:[self requestURLString]];
    
    //Set Mutable URL Request
    self.requestMutableURLRequest = [NSMutableURLRequest requestWithURL:[self requestURL]];
    
    //Set (CONSTANT) Mutable Request Parameters
    [[self requestMutableURLRequest] setValue:REQUEST_HTTP_HEADER_FIELD_VALUE forHTTPHeaderField:REQUEST_HTTP_HEADER_FIELD];
    
    //Set Method Parameter (as determined above)
    [[self requestMutableURLRequest] setHTTPMethod:[self requestHTTPMethod]];
    
    //**Memory cleanup**
    [action release];
    
    /*
     * End of common code between GET and POST/PUT/DELETE
     * Marshalls the service calls
     */
    
    if (railsServiceRequest.requestActionCode == kActionGETindex 
        || railsServiceRequest.requestActionCode == kActionGETshow) {
        
        return [self sendRailsServiceRequest:railsServiceRequest mutableURLRequest:[self requestMutableURLRequest]];
    } 
    else if (railsServiceRequest.requestActionCode == kActionPOSTcreate 
             || railsServiceRequest.requestActionCode == kActionPUTupdate 
             || railsServiceRequest.requestActionCode == kActionDELETEdestroy) {
        
        return [self sendRailsServiceRequest:railsServiceRequest 
                           mutableURLRequest:[self requestMutableURLRequest] 
                       requestHTTPParameters:[railsServiceRequest.requestData JSONRepresentation]];
    }
    else {
        return FALSE;
    }
}


#pragma mark - PRIVATE internal methods

/*
 * Used for GET actions
 */
- (BOOL)sendRailsServiceRequest:(RailsServiceRequest *)railsServiceRequest mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest {

    self.requestURLConnection = [NSURLConnection connectionWithRequest:mutableURLRequest delegate:self];
    
    if (self.requestURLConnection != nil) {
        self.responseData = [[NSMutableData alloc] init];
        return TRUE;
    }
    return FALSE;
}

/*
 * Used for POST/PUT/DELETE
 */
- (BOOL)sendRailsServiceRequest:(RailsServiceRequest *)railsServiceRequest mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest requestHTTPParameters:(NSString *)requestHTTPParameters {
    
    self.requestJSONData = [[NSData alloc] initWithData:[requestHTTPParameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [mutableURLRequest setValue:[[NSNumber numberWithInt:[self.requestJSONData length]] stringValue] 
             forHTTPHeaderField:REQUEST_HTTP_HEADER_FIELD_LENGTH];
    
    [mutableURLRequest setHTTPBody:[self requestJSONData]];    
    
    self.requestURLConnection = [NSURLConnection connectionWithRequest:mutableURLRequest delegate:self];
    
    if (self.requestURLConnection != nil) {
        self.responseData = [[NSMutableData alloc] init];
        return TRUE;
    }
    return FALSE;
}


#pragma mark - NSURLConnection Delegate methods - REQUIRED

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //Upon response - clear existing data
    [self.responseData setLength:0];
    
    //ONLY for Session Model
    if (__railsServiceRequest.requestActionCode == kActionPOSTcreate) {
        if ([__railsServiceRequest.requestModel isEqualToString:RAILS_MODEL_SESSIONS]) {
            
            NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
            
            if ([response respondsToSelector:@selector(allHeaderFields)]) {
                NSDictionary *headerFields = [httpURLResponse allHeaderFields];
                
                NSLog(@"HTTP Response %@", [headerFields description]);
                
                NSString *sessionToken = [headerFields objectForKey:@"Set-Cookie"];
                
                if (sessionToken != nil) {
                    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
                    delegate.sessionToken=[[NSString alloc] initWithString:sessionToken];
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
    //Upon data reception - append the data
    [self.responseData appendData:newData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //TODO: Identify what to do in non-development situation
    NSLog(@"Error on URL Connection: %@", [error description]);
}

/*
 * This method is invoked asynchronously upon a completed response
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //Data to responseString
    __railsServiceResponse.responseString = [[NSString alloc] initWithData:[self responseData] encoding:NSUTF8StringEncoding];
    
    //Temporary jsonParser
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    //Parser converts String --> NSDictionary
    NSDictionary *parsedJsonDictionary = [jsonParser objectWithString:__railsServiceResponse.responseString];
    
    /**
     * Below the parsing of items is for GET actions...
     */
    
    if (!parsedJsonDictionary) {
        NSLog(@"-JSONValue failed.  Error is: %@", [[jsonParser error] description]);
    }
    else {
        //Store set of items retrieved
        __railsServiceResponse.responseData = [parsedJsonDictionary objectForKey:@"items"];
        
        //Post notification that items were updated
        [[NSNotificationCenter defaultCenter] postNotificationName:[__railsServiceRequest requestResponseNotificationName] object:self];
    }
    
    //TODO: REMOVE DEBUG ENTRY
    NSLog(@"Response: %@", __railsServiceResponse.responseString);
    
    
    //Memory management
    //[responseString release];
    [jsonParser release];
}



@end
