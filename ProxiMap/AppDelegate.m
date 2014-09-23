//
//  AppDelegate.m
//  ProxiMap
//
//  Created by Patrick Hogan on 8/21/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"2U7bqZUy7btM3ofltsd0I2qdLFyaIDR995jQQUzn"
                  clientKey:@"NDxiYuXDLGB1BY9VSKoEG5dQKw55ydc7TP2eev84"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Avenir Next" size: 24.0], NSFontAttributeName, nil]];

    return YES;
}

@end
