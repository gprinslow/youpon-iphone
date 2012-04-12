//
//  OfferRedeemViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/6/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RailsService.h"

@interface OfferRedeemViewController : UIViewController <UIAlertViewDelegate> {
    NSMutableDictionary *data;
    
    RailsServiceRequest *offerValidateServiceRequest;
    RailsServiceResponse *offerValidateServiceResponse;
    
    UIActivityIndicatorView *actValidatingActivityIndicator;    
    UILabel *lblValidatingStatusMessage;
    UILabel *lblSuccessMessage;
    UILabel *lblSuccessDetailMessage;
    UILabel *lblFailureMessage;
    UILabel *lblFailureDetailMessage;
    UILabel *lblBackMessage;
    
}

@property (nonatomic, retain) NSMutableDictionary *data;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *actValidatingActivityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *lblValidatingStatusMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblSuccessMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblSuccessDetailMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblFailureMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblFailureDetailMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblBackMessage;


//Action methods
-(IBAction)validateRedemptionRequest:(id)sender;

//Service response delegate
-(void)validateOfferResponseReceived;


//Interface
-(void)refreshInterfaceFor:(NSString *)validatingStatusMessage successDetailMessage:(NSString *)successDetailMessage failureDetailMessage:(NSString *)failureDetailMessage isSuccess:(BOOL)isSuccess;

//Alert view
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
