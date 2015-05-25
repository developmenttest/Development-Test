//
//  AppDelegate.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"2eFUOgaSrzToUPfQUcoaS32V7ES8RqegU9DqvcGY" clientKey:@"NL4aWDgJ9R4in9eiVadddfyY71k2Bv6fOvq5bW8L"];
    return YES;
}

@end