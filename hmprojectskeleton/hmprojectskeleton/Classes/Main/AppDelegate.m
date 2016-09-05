//
//  AppDelegate.m
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

#import "AppDelegate.h"
#import "HMPAppearance.h"
#import "RootViewController.h"
#import "SideMenuViewController.h"
#import "RESideMenu.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [HMPAppearance initAppearance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [self createRootViewController];
    
    return YES;
}

/**
 *  Create root view controller, which is a RESideMenu type.
 *
 *  @return RESideMenu
 */
- (RESideMenu *)createRootViewController {
    SideMenuViewController *sideMenuViewController = [SideMenuViewController new];
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:sideMenuViewController rightMenuViewController:nil];
    return sideMenu;
}

@end
