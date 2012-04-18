//
//  OfferRedeemViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/6/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "OfferRedeemViewController.h"
#import "YouponAppDelegate.h"

//Local vars
UIAlertView *__offerRedeemErrorAlertView;
UIAlertView *__validationKeycodeInputAlertView;


static NSString *const RAILS_CREATE_VALIDATION_NOTIFICATION = @"RAILS_CREATE_VALIDATION_NOTIFICATION";

@implementation OfferRedeemViewController

@synthesize data;

@synthesize actValidatingActivityIndicator;
@synthesize lblValidatingStatusMessage;
@synthesize lblSuccessMessage;
@synthesize lblSuccessDetailMessage;
@synthesize lblFailureMessage;
@synthesize lblFailureDetailMessage;
@synthesize lblBackMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Interface
    self.title = @"";

    [lblValidatingStatusMessage setText:@"Validating with retailer..."];
    [lblValidatingStatusMessage setHidden:FALSE];
    
    [actValidatingActivityIndicator setHidden:FALSE];
    
    [lblSuccessMessage setText:@"Success!"];
    [lblSuccessMessage setHidden:TRUE];
    [lblSuccessDetailMessage setHidden:TRUE];
    
    [lblFailureMessage setText:@"Sorry..."];
    [lblFailureMessage setHidden:TRUE];
    [lblFailureDetailMessage setHidden:TRUE];
    
    [lblBackMessage setText:@"To look for more offers, use the back button"];
    
    //Service-related
    //data must be init'd by pushing controller
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(validateOfferResponseReceived) 
     name:RAILS_CREATE_VALIDATION_NOTIFICATION
     object:nil];
    
    //Automatically start validation
    [actValidatingActivityIndicator startAnimating];
    
    //Not sure why Int or BOOL did not result in correct comparison!!
    NSString *validationRequired = [NSString stringWithFormat:@"%@", [data valueForKey:@"validation_required"]];
    
    if ([validationRequired isEqualToString:@"1"]) {
        [self alertViewForKeycode:nil message:@"Ask retailer to validate now" title:@"Request Validation" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit"];
    }
    else {
        [self validateRedemptionRequest];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Service Actions
//Service initiator
-(void)validateRedemptionRequest {
    NSLog(@"Offer validation initiated");
    
    offerValidateServiceRequest = [[RailsServiceRequest alloc] init];
    offerValidateServiceResponse = [[RailsServiceResponse alloc] init];
    
    offerValidateServiceRequest.requestActionCode = 4; //POST-Create
    offerValidateServiceRequest.requestModel = RAILS_MODEL_VALIDATIONS;
    offerValidateServiceRequest.requestResponseNotificationName = RAILS_CREATE_VALIDATION_NOTIFICATION;
    [offerValidateServiceRequest.requestData setValue:data forKey:@"validation_request"];
    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[delegate railsService] callServiceWithRequest:offerValidateServiceRequest andResponsePointer:offerValidateServiceResponse]) {
        NSLog(@"Called CreateValidation");
    }
    else {
        NSLog(@"Call to CreateValidation failed");
    }
}

//Service response delegate
-(void)validateOfferResponseReceived {
    //TODO: check response and update messages accordingly
    NSLog(@"CreateValidation-ResponseReceived");
    
    for (id item in offerValidateServiceResponse.responseData) {
        NSLog(@"Response Item: %@", item);
    }
    
    if ([offerValidateServiceResponse.responseData objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[[offerValidateServiceResponse responseData] objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
        
        //TODO: probably not both alert & error message here - redundant
        [self refreshInterfaceFor:@"Validation failed..." successDetailMessage:nil failureDetailMessage:errorMessage isSuccess:FALSE];
    }
    else {
        //Successful validation
        [data setValue:[offerValidateServiceResponse responseData] forKey:@"validation"];
        
        [self refreshInterfaceFor:@"Validation succeeded..." successDetailMessage:@"Your request has been validated." failureDetailMessage:nil isSuccess:TRUE];
    }
}


#pragma mark - Interface
//Interface message change
-(void)refreshInterfaceFor:(NSString *)validatingStatusMessage successDetailMessage:(NSString *)successDetailMessage failureDetailMessage:(NSString *)failureDetailMessage isSuccess:(BOOL)isSuccess {
    
    if (isSuccess) {
        //Show validated (stop activity)
        [actValidatingActivityIndicator setHidden:TRUE];
        [lblValidatingStatusMessage setText:validatingStatusMessage];
        [lblValidatingStatusMessage setHidden:FALSE];
        
        //Show success message
        [lblSuccessMessage setHidden:FALSE];
        [lblSuccessDetailMessage setText:successDetailMessage];
        [lblSuccessDetailMessage setHidden:FALSE];
        
        //Hide failure message
        [lblFailureMessage setHidden:TRUE];
        [lblFailureDetailMessage setHidden:TRUE];
        
        [actValidatingActivityIndicator stopAnimating];
    }
    else {
        //Show validated (stop activity)
        [actValidatingActivityIndicator setHidden:TRUE];
        [lblValidatingStatusMessage setText:validatingStatusMessage];
        [lblValidatingStatusMessage setHidden:FALSE];
        
        //Show failure message
        [lblFailureMessage setHidden:FALSE];
        [lblFailureDetailMessage setText:failureDetailMessage];
        [lblFailureDetailMessage setHidden:FALSE];
        
        //Hide success message
        [lblSuccessMessage setHidden:TRUE];
        [lblSuccessDetailMessage setHidden:TRUE];
        
        [actValidatingActivityIndicator stopAnimating];
    }
}


#pragma mark - Alert view for Errors

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __offerRedeemErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__offerRedeemErrorAlertView show];
    [__offerRedeemErrorAlertView release];
    
    return FALSE;
}

#pragma mark - Alert view for Keycode entry

- (BOOL)alertViewForKeycode:(NSString *)keycode message:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    //Alert view for keycode entry
    __validationKeycodeInputAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [__validationKeycodeInputAlertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    
    [__validationKeycodeInputAlertView show];
    [__validationKeycodeInputAlertView release];
    
    return TRUE;
}


#pragma mark - Alert view delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == __offerRedeemErrorAlertView) {
        NSLog(@"error alert button was clicked");
    }
    else if (alertView == __validationKeycodeInputAlertView) {
        if (buttonIndex == 1) {
            //Submit button
            UITextField *keycode = [alertView textFieldAtIndex:0];
            
            NSLog(@"Keycode: %@", keycode.text);
            
            //Call validation service with keycode
            //Retrieve value & set in data dictionary
            [data setValue:[[alertView textFieldAtIndex:0] text] forKey:@"key_entry"];
            
            [self performSelector:@selector(validateRedemptionRequest) withObject:nil afterDelay:0.5];
        }
        else {
            //Cancel
            [actValidatingActivityIndicator stopAnimating];
            [actValidatingActivityIndicator setHidden:TRUE];
            [lblValidatingStatusMessage setText:@"Validation cancelled."];
            [lblValidatingStatusMessage setHidden:FALSE];
        }
    }
    else {
        NSLog(@"alert view was not recognized!");
    }
}

@end
