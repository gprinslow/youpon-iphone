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

@interface MapRootViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *_mapRootMapView;
    CLGeocoder *geocoder;
    CLLocation *currentLocation;
    CLLocationManager *locationManager;
    
    //Added for service calls
    NSMutableDictionary *data;
    NSArray *offers;
    RailsServiceRequest *offersMapServiceRequest;
    RailsServiceResponse *offersMapServiceResponse;
    RailsServiceRequest *offerMapServiceRequest;
    RailsServiceResponse *offerMapServiceResponse;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapRootMapView;
@property (nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

-(void)replotOffers;

-(void)getOffersResponseReceived;
-(void)getOfferResponseReceived;

- (void)geocodeLocation:(NSString *)addressString forAnnotation:(MapLocation *)annotation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;


@end
