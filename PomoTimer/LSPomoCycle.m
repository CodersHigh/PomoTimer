//
//  LSPomoCycle.m
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import "LSPomoCycle.h"

@implementation LSPomoCycle

- (id)init;
{
    self = [super init];
    if (self != nil){
        NSString *pomoTaskName = @"Work!";
        NSString *recessTaskName = @"Take a break..";
        NSMutableArray *pomoCycle = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray *recessCycle = [[NSMutableArray alloc] initWithCapacity:10];
        LSPomoTask *firstPomo = [[LSPomoTask alloc] init];
        firstPomo.taskTimeInSecond = POMODORO_TIME-1;
        firstPomo.typeOfTask = POMODORO;
        firstPomo.taskName = pomoTaskName;
        [pomoCycle addObject:firstPomo];
        
        LSPomoTask *firstRecess = [[LSPomoTask alloc] init];
        firstRecess.taskTimeInSecond = RECESS_TIME-1;
        firstRecess.typeOfTask = RECESS;
        firstRecess.taskName = recessTaskName;
        [recessCycle addObject:firstRecess];
        
        LSPomoTask *secondPomo = [[LSPomoTask alloc] init];
        secondPomo.taskTimeInSecond = POMODORO_TIME-1;
        secondPomo.typeOfTask = POMODORO;
        secondPomo.taskName = pomoTaskName;
        [pomoCycle addObject:secondPomo];
        
        LSPomoTask *secondRecess = [[LSPomoTask alloc] init];
        secondRecess.taskTimeInSecond = RECESS_TIME-1;
        secondRecess.typeOfTask = RECESS;
        secondRecess.taskName = recessTaskName;
        [recessCycle addObject:secondRecess];
        
        LSPomoTask *thirdPomo = [[LSPomoTask alloc] init];
        thirdPomo.taskTimeInSecond = POMODORO_TIME-1;
        thirdPomo.typeOfTask = POMODORO;
        thirdPomo.taskName = pomoTaskName;
        [pomoCycle addObject:thirdPomo];
        
        LSPomoTask *thirdRecess = [[LSPomoTask alloc] init];
        thirdRecess.taskTimeInSecond = RECESS_TIME-1;
        thirdRecess.typeOfTask = RECESS;
        thirdRecess.taskName = recessTaskName;
        [recessCycle addObject:thirdRecess];
        
        LSPomoTask *fourthPomo = [[LSPomoTask alloc] init];
        fourthPomo.taskTimeInSecond = POMODORO_TIME-1;
        fourthPomo.typeOfTask = POMODORO;
        fourthPomo.taskName = pomoTaskName;
        [pomoCycle addObject:fourthPomo];
        
        LSPomoTask *intermission = [[LSPomoTask alloc] init];
        intermission.taskTimeInSecond = RECESS_TIME-1;
        intermission.typeOfTask = RECESS;
        intermission.taskName = @"- - intermission - -";
        [recessCycle addObject:intermission];
        
        self.pomoArray = (NSArray *)pomoCycle;
        self.recessArray = (NSArray *)recessCycle;
        
    }
    return self;
}

- (void)dealloc
{
    self.currentTask = nil;
    self.pomoArray = nil;
    self.recessArray = nil;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil){
        self.pomoArray = [aDecoder decodeObjectForKey:@"PomoArray"];
        self.recessArray = [aDecoder decodeObjectForKey:@"RecessArray"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.pomoArray forKey:@"PomoArray"];
    [aCoder encodeObject:self.recessArray forKey:@"RecessArray"];
}

- (LSPomoTask *)currentTask
{
    if (_currentTask != nil && _currentTask.status < DONE){
        return _currentTask;
    } else {
        for (int i=0; i < [self.recessArray count]; i++) {
            LSPomoTask *pomoTask = [self.pomoArray objectAtIndex:i];
            LSPomoTask *recessTask = [self.recessArray objectAtIndex:i];
            if (pomoTask.status < DONE) {
                _currentTask = pomoTask;
                return _currentTask;
            } else if (pomoTask.status == DONE && recessTask.status < DONE)
            {
                _currentTask = recessTask;
                return _currentTask;
            }
        }
    }
    
    return nil;
}


- (void)resetCurrentTask
{
    LSPomoTask *currentTask = self.currentTask;
    if (currentTask.typeOfTask == POMODORO){
        [currentTask resetTask];
        currentTask.taskTimeInSecond = POMODORO_TIME;
    }
}


- (int)doneTaskCount
{
    int count = 0;
    for (LSPomoTask *pomoTask in _pomoArray) {
        if (pomoTask.status == DONE) count++;
    }
    
    return count;
}

- (int)startedTaskCount
{
    int count = 0;
    for (LSPomoTask *pomoTask in _pomoArray) {
        if (pomoTask.startDate != nil) count++;
    }
    
    return count;
}

- (BOOL)isTaskDone:(int)index
{
    LSPomoTask *currentTask = [self.pomoArray objectAtIndex:index];
    
    if (currentTask.status == DONE) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isTaskStarted:(int)index
{
    LSPomoTask *currentTask = [self.pomoArray objectAtIndex:index];
    
    if (currentTask.status > READY) {
        return YES;
    }
    
    return NO;
}

- (void)changeTaskName:(NSString *)newName atTaskIndex:(int)index
{
    NSMutableArray *newTaskArray = [NSMutableArray arrayWithArray:self.pomoArray];
    LSPomoTask *currentTask = [newTaskArray objectAtIndex:index];
    
    [currentTask setTaskName:newName];
    [newTaskArray replaceObjectAtIndex:index withObject:currentTask];
    
    self.pomoArray = (NSArray *)newTaskArray;
    
}

@end
