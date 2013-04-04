//
//  LSPomoFunction.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 9..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POMODORO_TIME 25*60
#define RECESS_TIME 5*60
#define INTERMISSION_TIME 30*60

//Keys
static NSString *kPomodoroDateKey = @"PomodoroDate";
static NSString *kPomodoroCyclesKey = @"PomodoroCycle";

//Notifications
static NSString *kPomodoroTaskDone = @"PomodoroTaskDone";
static NSString *kPomodoroTimeChanged = @"PomodoroTimeChanged";

NSString *documentDirectory();

int yearOfDate(NSDate *date);
int monthOfDate(NSDate *date);
int dayOfDate(NSDate *date);

BOOL isSameDay(NSDate *oneDate, NSDate *anotherDate);