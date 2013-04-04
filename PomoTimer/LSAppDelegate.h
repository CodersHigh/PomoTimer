//
//  LSAppDelegate.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPomoCycle.h"

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray *dailyPomodoroArray;
@property NSDictionary *todaysPomodoro;

@end
