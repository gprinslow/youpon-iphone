//
//  YouponAppDelegate.h
//  Youpon
//
//  Created by Garrison on 8/3/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouponAppDelegate : NSObject <UIApplicationDelegate> {

    UITabBarController *_rootTabBarController;
}
@property (nonatomic, retain) IBOutlet UITabBarController *rootTabBarController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
