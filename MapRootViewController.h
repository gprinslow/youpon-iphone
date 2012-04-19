//
//  MapRootViewController.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface MapRootViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapRootMapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapRootMapView;

@end
