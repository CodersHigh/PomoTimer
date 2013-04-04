//
//  LSViewController.m
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import "LSTaskViewController.h"
#import "LSPomoCycle.h"
@interface LSTaskViewController ()
{
    LSPomoCycle *_pomoCycle;
}
@end

@implementation LSTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"indexPathRow = %d", self.indexPathRow);
    
    _pomoCycle = [[LSPomoCycle alloc] initWithType:self.indexPathRow];
    [self updatePomodoroImageView];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelUpdate:) name:kPomodoroTimeChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomodoroUpdate:) name:kPomodoroTaskDone object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"indexPathRow = %d", self.indexPathRow);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPomodoroTaskDone object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPomodoroTimeChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startPause:(id)sender {
    UIButton *startPauseButton = (UIButton *)sender;
    
    int currentStatus = _pomoCycle.currentTask.status;
    if (currentStatus == READY || currentStatus == PAUSE){
        _pomoCycle.currentTask.status = COUNTING;
        [startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    } else if (currentStatus == COUNTING){
        _pomoCycle.currentTask.status = PAUSE;
        [startPauseButton setTitle:@"RESUME" forState:UIControlStateNormal];
    }
}

- (IBAction)stop:(id)sender {
    _pomoCycle = nil;    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)labelUpdate:(NSNotification *)notification
{
    LSPomoTask *currentTask = [notification object];
    int timesLeft = currentTask.taskTimeInSecond;
    int taskMinute = timesLeft/60;
    int taskSecond = timesLeft%60;
    
    NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", taskMinute, taskSecond];
    self.timeLabel.text = timeString;
}

- (void)pomodoroUpdate:(NSNotification *)notification
{
    
    LSPomoTask *doneTask = [notification object];
    if (doneTask.typeOfTask == POMODORO){
        [self updatePomodoroImageView];
    }
    
    LSPomoTask *newTask = _pomoCycle.currentTask;
    if (newTask == nil){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updatePomodoroImageView
{
    LSPomoTask *task;

    for (int i = 0; i < [_pomoCycle.taskArray count]; i++) {
        task = [_pomoCycle.taskArray objectAtIndex:i];
        if (task.typeOfTask == POMODORO) {
            UIImageView *pomodoroImageView = (UIImageView *)[self.view viewWithTag:(500+i)];
            NSString *pomodoroImageName;
            switch (task.status) {
                case READY: case PAUSE: case COUNTING:
                    pomodoroImageName = @"Pomodoro_Off";
                    break;
                case DONE:
                    pomodoroImageName = @"Pomodoro_On";
                    break;
            }
            pomodoroImageView.image = [UIImage imageNamed:pomodoroImageName];
        }
    }
}
@end
