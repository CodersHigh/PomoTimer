//
//  LSTaskViewController.m
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import "LSTaskViewController.h"
#import "LSPomoCycle.h"
#import "LSAppDelegate.h"
#import "LSNumberPushingView.h"

@interface LSTaskViewController ()
{
    LSPomoCycle *_pomoCycle;
    NSMutableArray *_pomoCycleArray;
    
    LSNumberPushingView *_cycleView;
    LSNumberPushingView *_minute10Unit;
    LSNumberPushingView *_minute1Unit;
    LSNumberPushingView *_second10Unit;
    LSNumberPushingView *_second1Unit;
    
}
@end

@implementation LSTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self viewInitialize];
    
    LSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.todaysPomodoroDict = appDelegate.todaysPomodoro;
    
    if (self.todaysPomodoroDict != nil){
        _pomoCycleArray = [[NSMutableArray alloc] initWithArray:[self.todaysPomodoroDict valueForKey:kPomodoroCyclesKey]];
        _pomoCycle = [_pomoCycleArray lastObject];
    } else {
        _pomoCycleArray = [[NSMutableArray alloc] initWithCapacity:10];
        [self createNewPomoCycle];
        
        NSDictionary *todaysNewPomoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSDate date], kPomodoroDateKey, _pomoCycleArray, kPomodoroCyclesKey, nil];
        self.todaysPomodoroDict = todaysNewPomoDict;
        appDelegate.todaysPomodoro = self.todaysPomodoroDict;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(counterUpdate:) name:kPomodoroTimeChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomodoroUpdate:) name:kPomodoroTaskDone object:nil];
    
    [self pomodoroUpdate:nil];
    [self buttonUpdate];
    [self counterUpdate:nil];
}

- (void)viewInitialize
{
    _cycleView = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(40, 35, 38, 29) numType:CYCLE_NUM];
    _cycleView.maxNum = 9;
    [self.recordView addSubview:_cycleView];
    
    _minute10Unit = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(32, 40, 55, 72) numType:TIMER_NUM];
    _minute1Unit = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(90, 40, 55, 72) numType:TIMER_NUM];
    
    _minute10Unit.maxNum = 5;
    _minute1Unit.maxNum = 9;
    
    _second10Unit = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(170, 40, 55, 72) numType:TIMER_NUM];
    _second1Unit = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(227, 40, 55, 72) numType:TIMER_NUM];
    
    _second10Unit.maxNum = 5;
    _second1Unit.maxNum = 9;
    
    [self.taskView addSubview:_minute10Unit];
    [self.taskView addSubview:_minute1Unit];
    [self.taskView addSubview:_second10Unit];
    [self.taskView addSubview:_second1Unit];
    
    UIImageView *colon = [[UIImageView alloc] initWithFrame:CGRectMake(152, 40, 12, 72)];
    colon.image =[UIImage imageNamed:@"colon"];
    
    [self.taskView addSubview:colon];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *dateString = [NSString stringWithFormat:@"%d월 %d일의 작업", monthOfDate([NSDate date]),dayOfDate([NSDate date])];
    self.dateLabel.text = dateString;
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

- (void)createNewPomoCycle
{
    _pomoCycle = [[LSPomoCycle alloc] init];
    [_pomoCycleArray addObject:_pomoCycle];
    
    int count = [_pomoCycleArray count] -1;
    
    _cycleView.targetPanelNum = count%10;
    
    [self updatePomodoroImageView];
}


- (IBAction)startPause:(id)sender {
    
    LSPomoTask *currentTask = _pomoCycle.currentTask;
    
    int currentStatus = currentTask.status;
    
    //For Debuging - Of No Use
    int currentTime = currentTask.taskTimeInSecond;
    //
    
    if (currentStatus == READY || currentStatus == PAUSE){
        currentTask.status = COUNTING;
    } else if (currentStatus == COUNTING){
        currentTask.status = PAUSE;
    }
    
    [self buttonUpdate];
}

- (IBAction)reset:(id)sender {
    [_pomoCycle resetCurrentTask];
    [self buttonUpdate];
}

- (void)buttonUpdate
{
    int currentStatus = _pomoCycle.currentTask.status;
    NSString *buttonLabel;
    switch (currentStatus) {
        case READY:
            buttonLabel = @"START";
            break;
        case COUNTING:
            buttonLabel = @"PAUSE";
            break;
        case PAUSE:
            buttonLabel = @"RESUME";
            break;
    }
    
    [self.startButton setTitle:buttonLabel forState:UIControlStateNormal];
}


- (void)counterUpdate:(NSNotification *)notification
{
    LSPomoTask *currentTask;
    if (notification != nil){
        currentTask = [notification object];
    } else {
        currentTask = _pomoCycle.currentTask;
    }
    int timesLeft = currentTask.taskTimeInSecond;
    int taskMinute = timesLeft/60;
    int taskSecond = timesLeft%60;
    
    _minute10Unit.targetPanelNum = taskMinute/10;
    _minute1Unit.targetPanelNum = taskMinute%10;
    _second10Unit.targetPanelNum = taskSecond/10;
    _second1Unit.targetPanelNum = taskSecond%10;
}

- (void)pomodoroUpdate:(NSNotification *)notification
{
    LSPomoTask *doneTask = [notification object];
    if (doneTask.typeOfTask == POMODORO){
        [self updatePomodoroImageView];
    }
    
    
    //뽀모도로 사이클이 끝난 것이므로 새로운 사이클을 만들어야 한다. AppDelegate에 넣는 것도 잊지말고.
    LSPomoTask *newTask = _pomoCycle.currentTask;
    if (newTask == nil){
        [self createNewPomoCycle];
        _pomoCycle.currentTask.status = COUNTING;
    }
}

- (void)updatePomodoroImageView
{
    LSPomoTask *task;
    
    for (int i = 0; i < [_pomoCycle.taskArray count]; i++) {
        task = [_pomoCycle.taskArray objectAtIndex:i];
        if (task.typeOfTask == POMODORO) {
            UIImageView *pomodoroImageView = (UIImageView *)[self.recordView viewWithTag:(500+i)];
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
