//
//  MapLocation.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation> {
    NSString *_title;
    NSString *_subtitle;
    NSString *_addressString;
    CLPlacemark *_placemark;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, copy) CLPlacemark *placemark;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle addressString:(NSString *)addressString placemark:(CLPlacemark *)placemark; 

@end
