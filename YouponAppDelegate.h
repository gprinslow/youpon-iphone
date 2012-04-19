//
//  YouponAppDelegate.h
//  Youpon
//
//  Created by Garrison on 8/3/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRootTableViewController.h"
#import "RailsService.h"
#import "MapLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface YouponAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
    
    UITabBarController *_rootTabBarController;
    UINavigationController *_loginNavigationController;
    LoginRootTableViewController *_loginRootTableViewController;
    //added
    RailsService *_railsService;
    NSString *_sessionToken;
    NSDictionary *_currentUser;
    
    CLLocationManager *_locationManager;
    CLLocation *_currentLocation;
}

@property (nonatomic, retain) IBOutlet UITabBarController *rootTabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *loginNavigationController;
@property (nonatomic, retain) IBOutlet LoginRootTableViewController *loginRootTableViewController;
//added
@property (nonatomic, retain) RailsService *railsService;
@property (nonatomic, retain) NSString *sessionToken;
@property (nonatomic, retain) NSDictionary *currentUser;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;


//Custom methods
- (void)presentDelayedModalViewController;


//Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;


@end
