//
//  OfferRedeemViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/6/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "OfferRedeemViewController.h"

//Local vars
UIAlertView *__offerRedeemErrorAlertView;


@implementation OfferRedeemViewController

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
    
    [lblValidatingStatusMessage setText:@"Validating with retailer..."];
    [lblValidatingStatusMessage setHidden:FALSE];
    
    [actValidatingActivityIndicator setHidden:FALSE];
    
    [lblSuccessMessage setText:@"Success!"];
    
    [lblFailureMessage setText:@"Sorry..."];
    
    [lblBackMessage setText:@"To look for more offers, use the back button"];
    
    [self performSelector:@selector(validateRedemptionRequest) withObject:nil afterDelay:0.5];
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
-(IBAction)validateRedemptionRequest:(id)sender {
    NSLog(@"Offer validition initiated");
}

//Service response delegate
-(void)validateOfferResponseReceived {
    
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
    }
}


#pragma mark - Alert view

- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    __offerRedeemErrorAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    [__offerRedeemErrorAlertView show];
    [__offerRedeemErrorAlertView release];
    
    return FALSE;
}

@end
