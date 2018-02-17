//
//  AppDelegate.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "AppDelegate.h"
#import "CURSplashScreenViewController.h"
#import "CURNetworkManagerProtocol.h"
#import "CURCoreDataManager.h"

@interface UIViewController () <CURNetworkManagerProtocol>

@end

@interface AppDelegate ()

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CURSplashScreenViewController *firstViewController = [CURSplashScreenViewController new];
    self.window.rootViewController = firstViewController;
    
    self.coreDataManager = [CURCoreDataManager new];
    firstViewController.coreDataManager = self.coreDataManager;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    UINavigationController *navigationViewController = (UINavigationController *)self.window.rootViewController.presentedViewController;
    [navigationViewController.topViewController saveReceivedURL:url];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.coreDataManager saveContext];
}

@end
