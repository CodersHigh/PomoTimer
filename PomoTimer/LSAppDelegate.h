//
//  LSAppDelegate.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray *dailyPomodoroArray;
@property NSDictionary *todaysPomodoro;
@property (readonly) NSMutableArray *todaysPomoCycleArray;

- (void)createNewPomoCycle;
- (void)changeTodaysPomoCycleArray:(NSArray *)newArray;
@end
