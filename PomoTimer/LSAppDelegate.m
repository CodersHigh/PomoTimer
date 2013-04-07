//
//  LSAppDelegate.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSAppDelegate.h"

static NSString *PomodoroFileName = @"Pomodoro.pmtmr";

@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *filePath = [documentDirectory() stringByAppendingPathComponent:PomodoroFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSArray *unarchArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _dailyPomodoroArray = [[NSMutableArray alloc] initWithArray:unarchArray];
    } else {
        _dailyPomodoroArray = [[NSMutableArray alloc] initWithCapacity:10];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSString *filePath = [documentDirectory() stringByAppendingPathComponent:PomodoroFileName];
    
    [NSKeyedArchiver archiveRootObject:_dailyPomodoroArray toFile:filePath];
}

- (NSDictionary *)todaysPomodoro
{
    NSDictionary *lastDailyPomo = [_dailyPomodoroArray lastObject];
    if (lastDailyPomo != nil){
        NSDate *lastPomoDate = [lastDailyPomo valueForKey:@"PomodoroDate"];
        if (isSameDay(lastPomoDate, [NSDate date]))
            return lastDailyPomo;
    }
    
    lastDailyPomo = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], kPomodoroDateKey, [NSArray array], kPomodoroCyclesKey, nil];
    [_dailyPomodoroArray addObject:lastDailyPomo];
    
    return lastDailyPomo;
}

- (void)setTodaysPomodoro:(NSDictionary *)todaysPomodoro
{
    NSDictionary *lastDailyPomo = [_dailyPomodoroArray lastObject];
    if (lastDailyPomo != nil){
        NSDate *lastPomoDate = [lastDailyPomo valueForKey:@"PomodoroDate"];
        if (isSameDay(lastPomoDate, [NSDate date])){
            [_dailyPomodoroArray removeLastObject];
        }
    }
    [_dailyPomodoroArray addObject:todaysPomodoro];
}

- (NSMutableArray *)todaysPomoCycleArray
{
    NSMutableArray *pomoCycle = [[NSMutableArray alloc] initWithArray:[self.todaysPomodoro valueForKey:kPomodoroCyclesKey]];
    return pomoCycle;
}

- (void)createNewPomoCycle
{
    NSMutableArray *pomoCycles = [self todaysPomoCycleArray];
    
    LSPomoCycle *newCycle = [[LSPomoCycle alloc] init];
    [pomoCycles addObject:newCycle];
    
    NSMutableDictionary *newTodayDict = [NSMutableDictionary dictionaryWithDictionary:self.todaysPomodoro];
    [newTodayDict setValue:pomoCycles forKey:kPomodoroCyclesKey];
    self.todaysPomodoro = newTodayDict;
}
@end
