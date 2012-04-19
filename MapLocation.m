//
//  MapLocation.m
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

@synthesize offerName = _offerName;
@synthesize merchantName = _merchantName;
@synthesize addressString = _addressString;
@synthesize placemark = _placemark;

- (id)initWithOfferName:(NSString *)offerName merchantName:(NSString *)merchantName addressString:(NSString *)addressString placemark:(CLPlacemark *)placemark {
    
    if ((self = [super init])) {
        _offerName = offerName;
        _merchantName = merchantName;
        _addressString = addressString;
        _placemark = placemark;
    }
    return self;
}

- (NSString *)title {
    return _offerName;
}

- (NSString *)subtitle {
    return _addressString;
}


@end
