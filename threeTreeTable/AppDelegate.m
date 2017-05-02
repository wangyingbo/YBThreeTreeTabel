//
//  AppDelegate.m
//  threeTreeTable
//
//  Created by EDZ on 2017/4/28.
//  Copyright © 2017年 王颖博. All rights reserved.
//

#import "AppDelegate.h"
#import "YBThreeTreeVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YBThreeTreeVC *three = [[YBThreeTreeVC alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:three];
    self.window.rootViewController = nav;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
