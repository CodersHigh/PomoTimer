//
//  LSAppDelegate.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSPomoCycle.h"
#import "LSPomoTask.h"
#import "LSTaskViewController.h"

static NSString *PomodoroFileName = @"Pomodoro.pmtmr";
static NSString *kBackgroundDateKey = @"BackgroundDate";

@interface LSAppDelegate ()
//{
//    NSDate *_backgroundDate;
//}

@end
@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s", __FUNCTION__);
    // Override point for customization after application launch.

    NSString *filePath = [documentDirectory() stringByAppendingPathComponent:PomodoroFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSArray *unarchArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _dailyPomodoroArray = [[NSMutableArray alloc] initWithArray:unarchArray];
    } else {
        _dailyPomodoroArray = [[NSMutableArray alloc] initWithCapacity:10];
    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    [self addObserver:self forKeyPath:@"backgroundDate" options:NULL context:nil];
    
    NSDate *userDefaultBackgroundDate = [[NSUserDefaults standardUserDefaults] objectForKey:kBackgroundDateKey];
    if (isSameDay(userDefaultBackgroundDate, [NSDate date])){
        _backgroundDate = userDefaultBackgroundDate;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    _backgroundDate = [NSDate date];
    NSLog(@"%s \r\n date = %@", __FUNCTION__, _backgroundDate);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _backgroundDate = [NSDate date];
    
    NSString *filePath = [documentDirectory() stringByAppendingPathComponent:PomodoroFileName];
    
    [NSKeyedArchiver archiveRootObject:_dailyPomodoroArray toFile:filePath];
    
    NSLog(@"%s \r\n date = %@", __FUNCTION__, _backgroundDate);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s \r\n date = %@", __FUNCTION__, _backgroundDate);
    //앱을 껐다가 한 참 뒤에 다시 켜는 경우에 문제가 없을까? 즉, 날짜가 바뀌었을 때.
    //그 경우 Local Notification이 해결해 주겠지?
    
    
    
    UINavigationController *mainNavigationController = (UINavigationController *)self.window.rootViewController;
    LSTaskViewController *taskViewController = mainNavigationController.topViewController;
    
    LSPomoTask *currentTask = taskViewController.pomoCycle.currentTask;
    if (currentTask.status == COUNTING){
        int timeGap = [[NSDate date] timeIntervalSinceDate:_backgroundDate];
        int currentTaskTime = currentTask.taskTimeInSecond;
        int resultTime = currentTaskTime - timeGap;
        currentTask.taskTimeInSecond = resultTime;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"%s \r\n date = %@", __FUNCTION__, _backgroundDate);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSString *filePath = [documentDirectory() stringByAppendingPathComponent:PomodoroFileName];
    
    [NSKeyedArchiver archiveRootObject:_dailyPomodoroArray toFile:filePath];
    
    [[NSUserDefaults standardUserDefaults] setObject:_backgroundDate forKey:kBackgroundDateKey];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"backgroundDate"]){
        [[NSUserDefaults standardUserDefaults] setObject:self.backgroundDate forKey:kBackgroundDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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

- (void)changeTodaysPomoCycleArray:(NSArray *)newArray
{
    NSMutableDictionary *newTodayDict = [NSMutableDictionary dictionaryWithDictionary:self.todaysPomodoro];
    [newTodayDict setValue:newArray forKey:kPomodoroCyclesKey];
    self.todaysPomodoro = newTodayDict;
}
@end
