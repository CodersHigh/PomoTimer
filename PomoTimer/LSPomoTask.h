//
//  LSPomoTask.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

static NSString *kPomodoroTaskDone = @"PomodoroTaskDone";
static NSString *kPomodoroTimeChanged = @"PomodoroTimeChanged";

@interface LSPomoTask : NSObject

- (void)stopTask;

@property int taskTimeInSecond;

@property int typeOfTask;
#define POMODORO 1
#define RECESS 0

@property int status;
#define READY 0
#define COUNTING 1
#define PAUSE 2
#define DONE 3

@end
