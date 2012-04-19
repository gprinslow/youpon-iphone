//
//  MapRootViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapLocation.h"

#import "RailsService.h"

#define METERS_PER_MILE 1609.344

@interface MapRootViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *_mapRootMapView;
    
    //Added for service calls
    NSMutableDictionary *data;
    NSArray *offers;
    RailsServiceRequest *offersMapServiceRequest;
    RailsServiceResponse *offersMapServiceResponse;
    RailsServiceRequest *offerMapServiceRequest;
    RailsServiceResponse *offerMapServiceResponse;
    
    CLGeocoder *_geocoder;
}

//@property (nonatomic, retain) IBOutlet MKMapView *mapRootMapView;

-(void)replotOffers;

-(void)getOffersResponseReceived;
-(void)getOfferResponseReceived;

-(IBAction)goToPinDetail:(id)sender;

//Geocoder
- (void)geocodeLocation:(NSString *)addressString forAnnotation:(MapLocation *)annotation;

@end
