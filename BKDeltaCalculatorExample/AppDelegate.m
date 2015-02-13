// Copyright 2015-present Andrew Toulouse.

#import "AppDelegate.h"

#import "TableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
