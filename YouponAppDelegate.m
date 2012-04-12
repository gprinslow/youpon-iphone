//
//  YouponAppDelegate.m
//  Youpon
//
//  Created by Garrison on 8/3/11.
//  Copyright 2011 Garrison Prinslow. All rights reserved.
//

#import "YouponAppDelegate.h"

@implementation YouponAppDelegate


@synthesize rootTabBarController = _rootTabBarController;
@synthesize loginNavigationController = _loginNavigationController;
@synthesize loginRootTableViewController = _loginRootTableViewController;
@synthesize railsService = _railsService;
@synthesize sessionToken = _sessionToken;
@synthesize currentUser = _currentUser;
@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Alloc & init the railsService for later use
    self.railsService = [[RailsService alloc] init];
    
    
    //Init the LoginRootTableView
    self.loginRootTableViewController = [[LoginRootTableViewController alloc] initWithNibName:@"LoginRootTableViewController" bundle:nil];
    
    //Init the LoginNavController w/RootTableView as Root
    self.loginNavigationController = [[UINavigationController alloc] initWithRootViewController:self.loginRootTableViewController];    
    
    //Set root tab bar controller as window's root view controller
    self.window.rootViewController = self.rootTabBarController;
    
    [self performSelector:@selector(presentDelayedModalViewController) withObject:nil afterDelay:0.1];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)presentDelayedModalViewController {
    //Present the LoginView - modally
    [self.rootTabBarController presentModalViewController:self.loginNavigationController animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_rootTabBarController release];
    [_loginNavigationController release];
    [_loginRootTableViewController release];
    [_railsService release];
    [_sessionToken release];
    [_currentUser release];

    [super dealloc];
}

#pragma mark - Tab Bar Controller Delegate methods

// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    //TODO: fill in didSelectViewController
}

// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
    //TODO: fill in didEndCustomizingViewControllers (if needed)
}

@end
