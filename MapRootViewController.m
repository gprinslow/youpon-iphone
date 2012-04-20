//
//  MapRootViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "MapRootViewController.h"
#import "MapLocation.h"
#import "YouponAppDelegate.h"

NSString *const GET_OFFERS_MAP_RESPONSE_NOTIFICATION_NAME = @"GET_OFFERS_MAP_RESPONSE";
NSString *const GET_OFFER_MAP_RESPONSE_NOTIFICATION_NAME = @"GET_OFFER_MAP_RESPONSE";

@implementation MapRootViewController

//@synthesize mapRootMapView = _mapRootMapView;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Geocoder
    _geocoder = [[CLGeocoder alloc] init];
    
    //MapView delegate
    _mapRootMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 367.0)];
    _mapRootMapView.delegate = self;
    [_mapRootMapView setShowsUserLocation:TRUE];
    [_mapRootMapView setZoomEnabled:TRUE];
    
    self.view = _mapRootMapView;
    
    //Service delegates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOffersResponseReceived) name:GET_OFFERS_MAP_RESPONSE_NOTIFICATION_NAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOfferResponseReceived) name:GET_OFFER_MAP_RESPONSE_NOTIFICATION_NAME object:nil];
    
    //Move to center    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *currentloc = delegate.locationManager.location;
    CLLocationCoordinate2D center = currentloc.coordinate;
    [_mapRootMapView setCenterCoordinate:center animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    CLLocation *currentloc = delegate.locationManager.location;
    CLLocationCoordinate2D centercoord = currentloc.coordinate;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(centercoord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapRootMapView regionThatFits:viewRegion];
    
    [_mapRootMapView setRegion:adjustedRegion animated:YES];
    
    [self replotOffers];
}

- (void)replotOffers {
    //Remove prior annotations
    for (id<MKAnnotation> annotation in _mapRootMapView.annotations) {
        [_mapRootMapView removeAnnotation:annotation];
    } 
    
    offersMapServiceRequest = [[RailsServiceRequest alloc] init];
    offersMapServiceResponse = [[RailsServiceResponse alloc] init];
    
    offerMapServiceRequest = [[RailsServiceRequest alloc] init];
    offerMapServiceResponse = [[RailsServiceResponse alloc] init];
    
    offersMapServiceRequest.requestActionCode = 0;
    offersMapServiceRequest.requestModel = RAILS_MODEL_OFFERS;
    offersMapServiceRequest.requestResponseNotificationName = GET_OFFERS_MAP_RESPONSE_NOTIFICATION_NAME;
    offersMapServiceRequest.requestData = nil;
    
    offerMapServiceRequest.requestActionCode = 1;
    offerMapServiceRequest.requestModel = RAILS_MODEL_OFFERS;
    offerMapServiceRequest.requestResponseNotificationName = GET_OFFER_MAP_RESPONSE_NOTIFICATION_NAME;
    offerMapServiceRequest.requestData = nil;
    
    YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([delegate sessionToken] != nil) {
        if ([[delegate railsService] callServiceWithRequest:offersMapServiceRequest andResponsePointer:offersMapServiceResponse]) {
            NSLog(@"Called Get - Map Offers");
        }
        else {
            NSLog(@"Call Get - Map Offers Failed");
        }
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



#pragma mark - Service response delegates

-(void)getOffersResponseReceived {
    //After receiving offers, make successive calls to getOffer;
    NSLog(@"Get Offers Map Response Received");
    
    if ([[offersMapServiceResponse responseData] objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[offersMapServiceResponse.responseData objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
    }
    //*  Step:  3)b: if success, sort and store data
    else {
        //Offers array is an array of NSDictionaries (each of which is an offer)
        offers = [[offersMapServiceResponse responseData] objectForKey:@"offers"];
        
        NSLog(@"Offers Response: %@", offers);
        
        YouponAppDelegate *delegate = (YouponAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (NSDictionary *offer in offers) {
            offerMapServiceRequest.requestData = [[NSMutableDictionary alloc] initWithDictionary:offer];
            if ([[delegate railsService] callServiceWithRequest:offerMapServiceRequest andResponsePointer:offerMapServiceResponse]) {
                NSLog(@"Called Get - Map Offer");
            }
            else {
                NSLog(@"Call Get - Map Offer Failed");
            }
        }
    }
}
-(void)getOfferResponseReceived {
    //On response, replot this offer
    NSLog(@"Get Offer Map Response Received");
    
    if ([[offerMapServiceResponse responseData] objectForKey:@"errors"]) {
        NSString *errorMessage = (NSString *)[[offerMapServiceResponse.responseData objectForKey:@"errors"] objectForKey:@"error"];
        
        NSLog(@"Error Response: %@", errorMessage);
    }
    //*  Step:  3)b: if success, sort and store data
    else {
        //Offers array is an array of NSDictionaries (each of which is an offer)
        NSDictionary *offer = [[NSDictionary alloc] initWithDictionary:[[offerMapServiceResponse responseData] objectForKey:@"offer"]];
        NSDictionary *location = [[NSDictionary alloc] initWithDictionary:[[offerMapServiceResponse responseData] objectForKey:@"location"]];
        
        NSLog(@"Offer: %@", offer);
        NSLog(@"Location: %@", location);
        
        NSString *offerName = [NSString stringWithFormat:@"%@", [offer valueForKey:@"title"]];
        //addr1 city state zip
        NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", [location valueForKey:@"address1"], [location valueForKey:@"city"], [location valueForKey:@"state"], [location valueForKey:@"zip"]];
        
        
        MapLocation *annotation = [[MapLocation alloc] initWithTitle:offerName subtitle:addressString addressString:addressString placemark:nil];
        
        [self geocodeLocation:addressString forAnnotation:annotation];
        [_mapRootMapView addAnnotation:annotation];
    }
}

-(IBAction)goToPinDetail:(id)sender {
    NSLog(@"Pin detail pressed");
}

#pragma mark - Map View Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    
    static NSString *identifier = @"CustomMapLocationAnnotationView";   
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MapLocation class]]) {
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[_mapRootMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView) {
            pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(goToPinDetail:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            
        }
        else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;    
}

#pragma mark - Geocoder
- (void)geocodeLocation:(NSString *)addressString forAnnotation:(MapLocation *)annotation {
    
    [_geocoder geocodeAddressString:addressString completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             NSLog(@"Placemark: %@", [placemarks objectAtIndex:0]);
             annotation.placemark = [[[CLPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]] autorelease];

             [_mapRootMapView addAnnotation:annotation];
             //viewForAnnotation will take care of the rest
         }
     }];
    
}



@end
