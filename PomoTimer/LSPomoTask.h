//
//  LSPomoTask.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

@interface LSPomoTask : NSObject <NSCoding>

@property int taskTimeInSecond;

@property int typeOfTask;
#define POMODORO 1
#define RECESS 0

@property int status;
#define READY 0
#define COUNTING 1
#define PAUSE 2
#define DONE 3

@property (nonatomic, retain) NSString *taskName;
@property NSDate *startDate;
@property NSDate *endDate;

- (NSString *)periodString;

- (void)resetTask;

@end
