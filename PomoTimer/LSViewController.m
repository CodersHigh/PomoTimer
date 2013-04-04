//
//  LSViewController.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSViewController.h"
#import <AudioToolbox/AudioServices.h>

@interface LSViewController (){
    NSTimer *_pomodoroTimer;
    int _taskTimeInSecond;
}
@end

@implementation LSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_taskTimeInSecond = 25*60;
    [self labelUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPause:(id)sender {
    UIButton *startPauseButton = (UIButton *)sender;
    
    BOOL isCounting = [_pomodoroTimer isValid];
    if (isCounting){
        [_pomodoroTimer invalidate];
        _pomodoroTimer = nil;
        [startPauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    } else {
        _pomodoroTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes:) userInfo:nil repeats:YES];
        
        [startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)stop:(id)sender {
    BOOL isCounting = [_pomodoroTimer isValid];
    if (isCounting){
        [_pomodoroTimer invalidate];
        _pomodoroTimer = nil;
    }
    _taskTimeInSecond = 25*60;
    [self labelUpdate];
}

- (void)timeGoes:(NSTimer *)timer
{
    if (_taskTimeInSecond > 0){
        _taskTimeInSecond--;
        [self labelUpdate];
    } else {
        [_pomodoroTimer invalidate];
        _pomodoroTimer = nil;
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        //http://iphonedevwiki.net/index.php/AudioServices
        AudioServicesPlayAlertSound(1005);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time's Up" message:@"Pomodoro time is up" delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self stop:nil];
}

- (void)labelUpdate
{
    int taskMinute = _taskTimeInSecond/60;
    int taskSecond = _taskTimeInSecond%60;
    
    NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", taskMinute, taskSecond];
    self.timeLabel.text = timeString;
}

@end
