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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"status"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int oldValue = [[change valueForKey:NSKeyValueChangeOldKey] intValue];
    int newValue = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
    
    if (oldValue == DONE){
        //에러처리
    }
    
    if (newValue == READY){
        //에러처리
    }
    
    switch (newValue) {
        case COUNTING:
            _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
            break;
            
        case PAUSE:
            [_pomodoroTimer invalidate];
            _pomodoroTimer = nil;
            break;
            
        case DONE:
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

- (void)stopTask
{
    [_pomodoroTimer invalidate];
    _pomodoroTimer = nil;
}
@end
