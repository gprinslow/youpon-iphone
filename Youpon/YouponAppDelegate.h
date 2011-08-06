//
//  YouponAppDelegate.h
//  Youpon
//
//  Created by Garrison on 8/3/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRootTableViewController.h"

@interface YouponAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UITabBarController *_rootTabBarController;
    LoginRootTableViewController *_loginRootTableViewController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *rootTabBarController;
@property (nonatomic, retain) IBOutlet LoginRootTableViewController *loginRootTableViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
