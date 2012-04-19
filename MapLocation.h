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
    NSString *_addressString;
    CLPlacemark *_placemark;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, retain) NSString *offerName;
@property (nonatomic, retain) NSString *merchantName;
@property (nonatomic, retain) NSString *addressString;
@property (nonatomic, retain) CLPlacemark *placemark;

- (id)initWithOfferName:(NSString *)offerName merchantName:(NSString *)merchantName addressString:(NSString *)addressString placemark:(CLPlacemark *)placemark; 

@end
