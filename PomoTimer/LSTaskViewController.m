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
#import "LSTimerButton.h"
#import "LSToDoTableViewController.h"

@interface LSTaskViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UIView *_timerView;
    LSTimerButton *_pomoTimerButton;
    UIButton *_resetButton;
    
    UIView *_recordView;
    LSNumberPushingView *_cycleView;
    
    UITableView *_todaysHistoryTableView;
    
    LSToDoTableViewController *_todoTableViewController;
}
@end

@implementation LSTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self viewInitialize];
    
    self.todaysPomodoroDict = [self appDelegate].todaysPomodoro;
    
    _pomoCycle = [self nextAvailableCycle];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pomodoroUpdate:) name:kPomodoroTaskDone object:nil];
    
    [self pomodoroUpdate:nil];
}

- (void)viewInitialize
{
    self.taskScrollView.scrollEnabled = YES;
    
    _timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 550)];
 
    _pomoTimerButton = [[LSTimerButton alloc] initWithFrame:CGRectMake(0,200,320, 320)];
    [_pomoTimerButton addTarget:self action:@selector(startPause) forControlEvents:UIControlEventTouchUpInside];
    [_timerView addSubview:_pomoTimerButton];
    
    _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 510, 60, 30)];
    [_resetButton setBackgroundImage:[UIImage imageNamed:@"button_reset"] forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [_timerView addSubview:_resetButton];
    
    [self.taskScrollView addSubview:_timerView];
    
    UINib *recordNib = [UINib nibWithNibName:@"RecordView" bundle:nil];
    NSArray *views = [recordNib instantiateWithOwner:self options:nil];
    _recordView = [views lastObject];
    _recordView.frame = CGRectMake(0, 20, 320, 60);
    
    _cycleView = [[LSNumberPushingView alloc] initWithFrame:CGRectMake(40, 12, 38, 29) numType:CYCLE_NUM];
    _cycleView.maxNum = 9;
    [_recordView addSubview:_cycleView];
    
    [self.taskScrollView addSubview:_recordView];
    
    _todaysHistoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 10) style:UITableViewStylePlain];
    _todaysHistoryTableView.scrollEnabled = NO;
    _todaysHistoryTableView.dataSource = self;
    _todaysHistoryTableView.delegate = self;
    [_todaysHistoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DetailCell"];
    
    [self.taskScrollView addSubview:_todaysHistoryTableView];

}

-(LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)createNewPomoCycle
{
    [[self appDelegate] createNewPomoCycle];
    
    int count = [[[self appDelegate] todaysPomoCycleArray] count] -1;
    
    _cycleView.targetPanelNum = count%10;
    
    [self updatePomodoroImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWorkTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateViewLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPomodoroTaskDone object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPause
{
    LSPomoTask *currentTask = _pomoCycle.currentTask;
    
    int currentStatus = currentTask.status;
    
    switch (currentStatus) {
        case READY:
            currentTask.status = COUNTING;
            break;
        case PAUSE:
            currentTask.status = COUNTING;
            break;
        case COUNTING:
            currentTask.status = PAUSE;
            break;
        default:
            break;
    }
    
    [_todaysHistoryTableView reloadData];
    [self updateViewLayout];
    [self updateTimerImageView];
}

- (IBAction)reset:(id)sender
{
    LSPomoTask *currentTask = _pomoCycle.currentTask;
    if (currentTask.typeOfTask == POMODORO) {
        [_pomoCycle resetCurrentTask];
        [self updateTimerImageView];
        [_todaysHistoryTableView reloadData];
    }
}

- (void)updateWorkTitle
{
    LSPomoTask *currentTask = _pomoCycle.currentTask;
    self.navigationItem.title = currentTask.taskName;
}

- (void)updateViewLayout
{
    float yPosition = 0;
    _timerView.frame = CGRectMake(0, yPosition-170, 320, 550);
    yPosition += 380;
    _recordView.frame = CGRectMake(0, yPosition, 320, 60);
    yPosition += 60;
    float tableViewHeight = _todaysHistoryTableView.contentSize.height;
    if (tableViewHeight > 0){
        _todaysHistoryTableView.frame = CGRectMake(0, yPosition, 320, tableViewHeight);
    }
    yPosition += tableViewHeight;
    self.taskScrollView.contentSize = CGSizeMake(320, yPosition);
}


- (void)pomodoroUpdate:(NSNotification *)notification
{
    LSPomoTask *doneTask = [notification object];
    if (doneTask.typeOfTask == POMODORO){
        [self updatePomodoroImageView];
    }
    
    //뽀모도로 사이클이 끝난 것이므로 새로운 사이클을 만들어야 한다. AppDelegate에 넣는 것도 잊지말고.
    LSPomoTask *newTask = _pomoCycle.currentTask;
    if (newTask == nil){//다음 사이클이 있는 경우 사이클 오브젝트 변경
        _pomoCycle = [self nextAvailableCycle];
        newTask = _pomoCycle.currentTask;
    }

    if (doneTask!= nil)
        newTask.status = COUNTING;
    
    
    [self updateTimerImageView];
    [_todaysHistoryTableView reloadData];
    [self updateViewLayout];
    [self updateWorkTitle];
}

- (LSPomoCycle *)nextAvailableCycle
{
    NSMutableArray *pomoCycles = [[self appDelegate] todaysPomoCycleArray];
    NSUInteger firstCycleIndex = [pomoCycles indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        if ([(LSPomoCycle *)obj doneTaskCount] < 4){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    NSLog(@"Next Cyce Index = %d", firstCycleIndex);
    if (firstCycleIndex != NSNotFound){
        _pomoCycle = [pomoCycles objectAtIndex:firstCycleIndex];
    } else {
        [self createNewPomoCycle];
    }
    return _pomoCycle;
}

- (void)updatePomodoroImageView
{
    LSPomoTask *task;
    
    for (int i = 0; i < [_pomoCycle.pomoArray count]; i++) {
        task = [_pomoCycle.pomoArray objectAtIndex:i];
        
        UIImageView *pomodoroImageView = (UIImageView *)[_recordView viewWithTag:(500+i)];
        UILabel *pomodoroNumberLabel = (UILabel *)[_recordView viewWithTag:(400+i)];
        NSString *pomodoroImageName;
        switch (task.status) {
            case READY: case PAUSE: case COUNTING:
                pomodoroImageName = @"Pomodoro_Off";
                pomodoroNumberLabel.font = [UIFont systemFontOfSize:8];
                pomodoroNumberLabel.textColor = [UIColor lightGrayColor];
                break;
            case DONE:
                pomodoroImageName = @"Pomodoro_On";
                pomodoroNumberLabel.font = [UIFont boldSystemFontOfSize:8];
                pomodoroNumberLabel.textColor = [UIColor darkGrayColor];
                break;
                
        }
        pomodoroImageView.image = [UIImage imageNamed:pomodoroImageName];
        
    }
}

- (void)updateTimerImageView
{
    LSPomoTask *currentTask = _pomoCycle.currentTask;
    [_pomoTimerButton updateTimerImage:currentTask];
    
    if (currentTask.typeOfTask == POMODORO) {
        switch (currentTask.status) {
            case COUNTING: case DONE: case READY:
                [_timerView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
                [_resetButton setBackgroundImage:[UIImage imageNamed:@"button_reset"] forState:UIControlStateNormal];
                break;
            case PAUSE:
                [_timerView setBackgroundColor:[UIColor colorWithRed:0.66 green:0.66 blue:0.76 alpha:1.0]];
                break;
            default:
                break;
        }
    } else if (currentTask.typeOfTask == RECESS)
    {
        [_timerView setBackgroundColor:[UIColor colorWithRed:0.82 green:0.65 blue:0.66 alpha:1.0]];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"button_reset_enable"] forState:UIControlStateNormal];
    }
}

- (IBAction)showTodoTable:(id)sender {
    
    _todoTableViewController =[[LSToDoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_todoTableViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (int)sectionCountForEntry
{
    int sectionCount = 0;
    for (LSPomoCycle *pomoCycle in [[self appDelegate] todaysPomoCycleArray]) {
        if ([pomoCycle startedTaskCount] > 0) sectionCount ++;
    }
    return sectionCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfCycle = [self sectionCountForEntry];
    return numberOfCycle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *pomoCycles = [[self appDelegate] todaysPomoCycleArray];
    int numOfCycle = [self sectionCountForEntry];
    LSPomoCycle *thisCycle = [pomoCycles objectAtIndex:numOfCycle - (section + 1)];
    int rowCount = [thisCycle startedTaskCount];
    
    if (rowCount == 0)
        rowCount++;
    NSLog(@"current section: %d, row count: %d", section, rowCount);
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    NSMutableArray *pomoCycles = [[self appDelegate] todaysPomoCycleArray];
    int numOfCycle = [self sectionCountForEntry];
    LSPomoCycle *pomoCycle = [pomoCycles objectAtIndex: numOfCycle - (indexPath.section +1)];
    
    int numOfPomo = [pomoCycle startedTaskCount];
    int pomoIndex = 0;
    if (numOfPomo > 0) pomoIndex = numOfPomo - (indexPath.row+1);
    LSPomoTask *currentTask = [pomoCycle.pomoArray objectAtIndex:pomoIndex];
    
    cell.textLabel.text = currentTask.taskName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",currentTask.periodString];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionLabel = [[UILabel alloc] init];
    int numOfCycle = [self sectionCountForEntry];
    sectionLabel.text = [NSString stringWithFormat:@"   Cycle %d", numOfCycle - section];
    sectionLabel.backgroundColor = [UIColor darkGrayColor];
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    return sectionLabel;
}

@end
