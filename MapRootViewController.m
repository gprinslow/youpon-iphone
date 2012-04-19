//
//  MapRootViewController.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "MapRootViewController.h"
#import "MapLocation.h"

@implementation MapRootViewController

@synthesize mapRootMapView = _mapRootMapView;

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
    
    //Move to center
    CLLocationCoordinate2D mapCenter = [_mapRootMapView centerCoordinate];
    mapCenter = [_mapRootMapView convertPoint:CGPointMake(1, (_mapRootMapView.frame.size.height/2.0)) toCoordinateFromView:_mapRootMapView];
    [_mapRootMapView setCenterCoordinate:mapCenter animated:YES];
    
    [self replotOffers];
}

- (void)viewDidAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 38.6303;
    zoomLocation.longitude = -90.2070;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapRootMapView regionThatFits:viewRegion];
    
    [_mapRootMapView setRegion:adjustedRegion animated:YES];
}

- (void)replotOffers {
    //Remove prior annotations
    for (id<MKAnnotation> annotation in _mapRootMapView.annotations) {
        [_mapRootMapView removeAnnotation:annotation];
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

#pragma mark - Map View Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapLocation";   
    if ([annotation isKindOfClass:[MapLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[_mapRootMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"172-pricetag.png"];
        
        return annotationView;
    }
    
    return nil;    
}


@end
