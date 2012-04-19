//
//  MapLocation.h
//  Youpon
//
//  Created by Garrison Prinslow on 4/19/12.
//  Copyright (c) 2012 Garrison Prinslow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation> {
    NSString *_offerName;
    NSString *_merchantName;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, retain) NSString *offerName;
@property (nonatomic, retain) NSString *merchantName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithOfferName:(NSString *)offerName merchantName:(NSString *)merchantName address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
