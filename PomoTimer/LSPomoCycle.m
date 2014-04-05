//
//  LSPomoCycle.m
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import "LSPomoCycle.h"

#define POMODORO_TIME 25*60
#define RECESS_TIME 5*60
#define INTERMISSION_TIME 30*60
@implementation LSPomoCycle


- (id)initWithType:(int)typeOfCycle;
{
    self = [super init];
    if (self != nil){
        NSMutableArray *pomoCycle = [[NSMutableArray alloc] initWithCapacity:10];
        LSPomoTask *firstPomo = [[LSPomoTask alloc] init];
        firstPomo.taskTimeInSecond = POMODORO_TIME;
        firstPomo.typeOfTask = POMODORO;
        [pomoCycle addObject:firstPomo];
        
        LSPomoTask *firstRecess = [[LSPomoTask alloc] init];
        firstRecess.taskTimeInSecond = RECESS_TIME;
        firstRecess.typeOfTask = RECESS;
        [pomoCycle addObject:firstRecess];
        
        if (typeOfCycle > 0) {
            LSPomoTask *secondPomo = [[LSPomoTask alloc] init];
            secondPomo.taskTimeInSecond = POMODORO_TIME;
            secondPomo.typeOfTask = POMODORO;
            [pomoCycle addObject:secondPomo];
            
            LSPomoTask *secondRecess = [[LSPomoTask alloc] init];
            secondRecess.taskTimeInSecond = RECESS_TIME;
            secondRecess.typeOfTask = RECESS;
            [pomoCycle addObject:secondRecess];
        }
        if (typeOfCycle > 1) {
            LSPomoTask *thirdPomo = [[LSPomoTask alloc] init];
            thirdPomo.taskTimeInSecond = POMODORO_TIME;
            thirdPomo.typeOfTask = POMODORO;
            [pomoCycle addObject:thirdPomo];
            
            LSPomoTask *thirdRecess = [[LSPomoTask alloc] init];
            thirdRecess.taskTimeInSecond = RECESS_TIME;
            thirdRecess.typeOfTask = RECESS;
            [pomoCycle addObject:thirdRecess];
        }
        if (typeOfCycle > 2) {
            LSPomoTask *fourthPomo = [[LSPomoTask alloc] init];
            fourthPomo.taskTimeInSecond = POMODORO_TIME;
            fourthPomo.typeOfTask = POMODORO;
            [pomoCycle addObject:fourthPomo];
            
            LSPomoTask *intermission = [[LSPomoTask alloc] init];
            intermission.taskTimeInSecond = INTERMISSION_TIME;
            intermission.typeOfTask = RECESS;
            [pomoCycle addObject:intermission];
        }
        
        self.taskArray = (NSArray *)pomoCycle;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startNextTask:) name:kPomodoroTaskDone object:nil];

    }
    return self;
}

- (void)dealloc
{
    [_currentTask stopTask];
    _taskArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPomodoroTaskDone object:nil];
}

- (LSPomoTask *)currentTask
{
    if (_currentTask != nil && _currentTask.status < DONE){
        return _currentTask;
    } else {
        for (LSPomoTask *task in self.taskArray) {
            if (task.status < DONE){
                _currentTask = task;
                return _currentTask;
            }
        }
    }
    return nil;
}

- (void)startNextTask:(NSNotification *)notification
{
    LSPomoTask *currentTask = self.currentTask;
    if (currentTask != nil && currentTask.status == READY){
        currentTask.status = COUNTING;
    }
}

@end
