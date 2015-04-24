//
//  AppDelegate.m
//  FingerTouchingArpeggiator
//
//  Created by kztskawamu on 2015/04/15.
//  Copyright (c) 2015年 kztskawamu. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/utsname.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
-(id)init{
    if(self = [super init]){
        _deviceName = getDeviceName();
        
        _is_Simulator =  ([_deviceName isEqualToString:@"i386"] || [_deviceName isEqualToString:@"x86_64"]);
        _is_iPhone4 = ([_deviceName hasPrefix:@"iPhone3,"] || [_deviceName isEqualToString:@"iPhone4,1"]);
        _is_iPhone5 = ([_deviceName hasPrefix:@"iPhone5,"] || [_deviceName hasPrefix:@"iPhone6,"]);
        _is_iPhone6 =  ([_deviceName isEqualToString:@"iPhone7,2"]);
        _is_iPhone6Plus =  ([_deviceName isEqualToString:@"iPhone7,1"]);
        _is_iPad = ([_deviceName hasPrefix:@"iPad"]);
        
        NSLog(@"Device Name: %@",_deviceName);
        NSLog(@"Is Simulator? => %@", _is_Simulator ? @"YES":@"NO");
        NSLog(@"Is iPhone4? => %@", _is_iPhone4 ? @"YES":@"NO");
        NSLog(@"Is iPhone5? => %@", _is_iPhone5 ? @"YES":@"NO");
        NSLog(@"Is iPhone6? => %@", _is_iPhone6 ? @"YES":@"NO");
        NSLog(@"Is iPhone6Plus? => %@", _is_iPhone6Plus ? @"YES":@"NO");
        NSLog(@"Is iPad? => %@", _is_iPad ? @"YES":@"NO");
        
    }
    return self;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    //window初期化
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main.storyboard"
//                                                         bundle:nil];
    
    UIViewController *viewController;
    
    if (_is_iPhone4) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"iPhone4"];
    }else if (_is_iPad) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"iPad"];
    }else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"iPhone"];
    }

    
    //    UITabBarController *mainViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

NSString* getDeviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
