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
}
@end

@implementation LSPomoTask

- (id)init
{
    self = [super init];
    if (self != nil){
        _status = READY;
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
}

- (NSString *)description
{
    NSString *descString = [NSString stringWithFormat:@"Type = %d , TimeLeft = %d\r\n Status = %d\r\n StartDate = %@\r\n EndDate = %@", _typeOfTask, _taskTimeInSecond, _status, _startDate, _endDate];
    
    return descString;
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"status"];
    [_pomodoroTimer invalidate];
    _pomodoroTimer = nil;
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
            break;
        case COUNTING:
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTimeChanged object:self];
            if (oldValue == READY & self.startDate == nil){
                self.startDate = [NSDate date];
            }
            _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
            break;
            
        case PAUSE:
            [_pomodoroTimer invalidate];
            _pomodoroTimer = nil;
            break;
            
        case DONE:
            self.endDate = [NSDate date];
            [_pomodoroTimer invalidate];
            _pomodoroTimer = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kPomodoroTaskDone object:self];
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
    [_pomodoroTimer invalidate];
    _pomodoroTimer = nil;
    self.status = READY;
    self.startDate = nil;
    self.endDate = nil;
}
@end
