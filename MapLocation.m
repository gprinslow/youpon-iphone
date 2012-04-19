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
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithOfferName:(NSString *)offerName merchantName:(NSString *)merchantName address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate {
    
    if ((self = [super init])) {
        _offerName = offerName;
        _merchantName = merchantName;
        _address = address;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _offerName;
}

- (NSString *)subtitle {
    return _address;
}


@end
