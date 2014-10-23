//
//  MLAppDelegate.m
//  MLNetworkLogger
//
//  Created by CocoaPods on 10/23/2014.
//  Copyright (c) 2014 MUSTLab Developer. All rights reserved.
//

#import <MLNetworkLogger.h>

#import "MLAppDelegate.h"

@implementation MLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[MLNetworkLogger sharedLogger] setRequestFilter:[MLHostnameRequestFilter filterWithHostnames:@[@"apple.com"]]];
    [[MLNetworkLogger sharedLogger] addAdapter:[MLAFNetworkingAdapter new]];
    [[MLNetworkLogger sharedLogger] setLogDetalization:MLNetworkLoggerLogDetalizationHigh];
    [[MLNetworkLogger sharedLogger] setRequestLogFormat:MLNetworkLoggerRequestLogFormatCURL];
    [[MLNetworkLogger sharedLogger] startLogging];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[MLNetworkLogger sharedLogger] stopLogging];
}

@end
