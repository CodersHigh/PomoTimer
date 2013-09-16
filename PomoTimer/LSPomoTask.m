//
//  LSPomoTask.m
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import "LSPomoTask.h"

@interface LSPomoTask ()
{
    NSTimer *_pomodoroTimer;
    UILocalNotification *_doneNotification;
}
- (void)invalidateTask;
@end

@implementation LSPomoTask

- (id)init
{
    self = [super init];
    if (self != nil){
        _status = READY;
        self.taskName = @"Non Title.";
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil){
        
        _taskTimeInSecond = [aDecoder decodeIntegerForKey:@"TaskTimeInSecond"];
        _typeOfTask = [aDecoder decodeIntegerForKey:@"TypeOfTask"];
        self.startDate = [aDecoder decodeObjectForKey:@"StartDate"];
        self.endDate = [aDecoder decodeObjectForKey:@"EndDate"];
        int unarchStatus = [aDecoder decodeIntegerForKey:@"Status"];
        self.taskName = [aDecoder decodeObjectForKey:@"TaskName"];
        
        if (unarchStatus == COUNTING){
            if (isSameDay(_startDate, [NSDate date])) {
                _status = COUNTING;
            } else {
                _status = PAUSE;
            }
        } else {
            _status = unarchStatus;
        }
        
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_taskTimeInSecond forKey:@"TaskTimeInSecond"];
    [aCoder encodeInteger:_typeOfTask forKey:@"TypeOfTask"];
    [aCoder encodeInteger:_status forKey:@"Status"];
    [aCoder encodeObject:_startDate forKey:@"StartDate"];
    [aCoder encodeObject:_endDate forKey:@"EndDate"];
    [aCoder encodeObject:_taskName forKey:@"TaskName"];
}

- (NSString *)description
{
    NSString *descString = [NSString stringWithFormat:@"Type = %d , Name = %@\r\n TimeLeft = %d\r\n Status = %d\r\n StartDate = %@\r\n EndDate = %@", _typeOfTask, _taskName, _taskTimeInSecond, _status, _startDate, _endDate];
    
    return descString;
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"status"];
    [self invalidateTask];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int oldValue = [[change valueForKey:NSKeyValueChangeOldKey] intValue];
    int newValue = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
    
    if (oldValue == newValue) return;
    
    if (oldValue == DONE){
        //에러처리
    }
    
    if (newValue == READY){
        //에러처리
        NSLog(@"New Value is READY");
    }
    
    switch (newValue) {
        case READY:
            self.taskTimeInSecond = POMODORO_TIME;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTimeChanged object:self];
            break;
        case COUNTING:
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTimeChanged object:self];
            if (oldValue == READY & self.startDate == nil){
                self.startDate = [NSDate date];
            }
            _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            _doneNotification = [[UILocalNotification alloc] init];
            _doneNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.taskTimeInSecond];
            _doneNotification.alertBody = [NSString stringWithFormat:@"Task %@ is done", self.taskName];
            _doneNotification.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:_doneNotification];
            break;
            
        case PAUSE:
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTimeChanged object:self];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            
            [self invalidateTask];
            break;
            
        case DONE:
            self.endDate = [NSDate date];
            [self invalidateTask];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTaskDone object:self];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            
            break;
    }
}


- (void)timeGoes:(NSTimer *)timer
{
    if (_taskTimeInSecond > 0){
        _taskTimeInSecond--;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTimeChanged object:self];
    } else {
        self.status = DONE;
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //http://iphonedevwiki.net/index.php/AudioServices
        AudioServicesPlayAlertSound(1005);
    }
}

- (void)resetTask
{
    [self invalidateTask];
    
    self.status = READY;
    self.startDate = nil;
    self.endDate = nil;
}

- (void)invalidateTask
{
    [_pomodoroTimer invalidate];
    _pomodoroTimer = nil;
    
    [[UIApplication sharedApplication] cancelLocalNotification:_doneNotification];
    _doneNotification = nil;
}

- (NSString *)periodString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    
    NSString *startDateString = [dateFormatter stringFromDate:self.startDate] == nil ? @"READY" : [dateFormatter stringFromDate:self.startDate];
    NSString *endDateString = [dateFormatter stringFromDate:self.endDate] == nil ? @"" : [dateFormatter stringFromDate:self.endDate];
    
    NSString *periodString = [NSString stringWithFormat:@"%@ ~ %@",startDateString, endDateString];
    
    return periodString;
}
@end
