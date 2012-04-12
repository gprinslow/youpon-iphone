//
//  OfferDetailTableViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/5/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedListTableViewController.h"
#import "NSArray+NestedArray.h"
#import "StringValueDisplay.h"
#import "RailsService.h"
#import "OfferRedeemViewController.h"

@interface OfferDetailTableViewController : GroupedListTableViewController <UIAlertViewDelegate> {
    
    RailsServiceRequest *offerRedemptionRequest;
    RailsServiceResponse *offerRedemptionResponse;
    
    OfferRedeemViewController *offerRedeemViewController;
    
    UIActivityIndicatorView *actRequestingRedemptionActivityIndicator;
}



//Table view mechanics
-(void)reloadTableViewData;

//Action methods
-(IBAction)redeemOffer:(id)sender;

//Service response delegate
-(void)createRedemptionRequest;
-(void)redemptionRequestResponseReceived;

//Alert view
- (BOOL)alertViewForError:(NSString *)message title:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
