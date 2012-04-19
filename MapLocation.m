//
//  MapLocation.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize addressString = _addressString;
@synthesize placemark = _placemark;
@synthesize coordinate = _coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        [self setTitle:title];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle addressString:(NSString *)addressString placemark:(CLPlacemark *)placemark {
    
    self = [super init];
    
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _addressString = addressString;
        _placemark = placemark;
        _coordinate = placemark.location.coordinate;
    }
    return self;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}


@end
