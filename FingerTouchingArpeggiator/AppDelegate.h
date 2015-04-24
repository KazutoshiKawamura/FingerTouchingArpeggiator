//
//  AppDelegate.h
//  FingerTouchingArpeggiator
//
//  Created by kztskawamu on 2015/04/15.
//  Copyright (c) 2015年 kztskawamu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) bool is_Simulator, is_iPhone4, is_iPhone5, is_iPhone6, is_iPhone6Plus, is_iPad;
@property(nonatomic) NSString *deviceName;
@end

