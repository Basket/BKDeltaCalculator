// Copyright 2015-present Andrew Toulouse.

#import "AppDelegate.h"

#import "CollectionViewController.h"
#import "TableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(40, 40);
    self.window.rootViewController = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
