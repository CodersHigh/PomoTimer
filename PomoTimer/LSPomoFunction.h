//
//  LSPomoFunction.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 9..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kPomodoroDateKey = @"PomodoroDate";
static NSString *kPomodoroCyclesKey = @"PomodoroCycle";

NSString *documentDirectory();

int yearOfDate(NSDate *date);
int monthOfDate(NSDate *date);
int dayOfDate(NSDate *date);

BOOL isSameDay(NSDate *oneDate, NSDate *anotherDate);