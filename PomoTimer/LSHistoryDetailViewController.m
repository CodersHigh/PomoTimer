//
//  LSHistoryDetailViewController.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 7..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSHistoryDetailViewController.h"
#import "LSPomoCycle.h"
#import "LSPomoTask.h"

@interface LSHistoryDetailViewController ()
{
    LSNumberPushingView *_cycleView;
}
@end

@implementation LSHistoryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*_cycleView = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(40, 45, 38, 29)];
    _cycleView.numType = CYCLE_NUM;
    
    [self.historyRecordView addSubview:_cycleView];
   
    NSArray *pomodoroCycleArray = [self.pomodoroOfTheDay valueForKey:@"PomodoroCycle"];
    _cycleView.targetPanelNum = [pomodoroCycleArray count]-1;
    
    LSPomoCycle *lastCycle = [pomodoroCycleArray lastObject];
    
    for (int i = 0; i < [lastCycle.taskArray count]; i++) {
        LSPomoTask *task = [lastCycle.taskArray objectAtIndex:i];
        if (task.typeOfTask == POMODORO) {
            UIImageView *pomodoroImageView = (UIImageView *)[self.historyRecordView viewWithTag:(500+i)];
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
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *pomodoroCycleArray = [self.pomodoroOfTheDay valueForKey:@"PomodoroCycle"];
    int numberOfCycle = [pomodoroCycleArray count];
    return numberOfCycle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *pomodoroCyleArray = [self.pomodoroOfTheDay valueForKey:@"PomodoroCycle"];
    LSPomoCycle *pomoCycle = [pomodoroCyleArray objectAtIndex:section];
    int rowCount = [pomoCycle doneTaskCount];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSArray *pomodoroCyleArray = [self.pomodoroOfTheDay valueForKey:@"PomodoroCycle"];
    LSPomoCycle *pomoCycle = [pomodoroCyleArray objectAtIndex:indexPath.section];
    LSPomoTask *currentTask = [pomoCycle.taskArray objectAtIndex:(indexPath.row * 2)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    
    NSString *startDateString = [dateFormatter stringFromDate:currentTask.startDate];
    NSString *endDateString = [dateFormatter stringFromDate:currentTask.endDate];
    
    NSString *periodString = [NSString stringWithFormat:@"%@ ~ %@",startDateString, endDateString];
    cell.textLabel.text = periodString;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerString = [NSString stringWithFormat:@"Pomodoro Cycle #%d", section + 1];
    return headerString;
}
@end
