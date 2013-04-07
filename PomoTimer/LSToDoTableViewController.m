//
//  LSToDoTableViewController.m
//  PomoToDoTable
//
//  Created by Lingostar on 13. 2. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSToDoTableViewController.h"
#import "LSPomoCycle.h"
#import "LSAppDelegate.h"
#import "LSPomoTask.h"

#define TASK_IN_CYCLE 4
@interface LSToDoTableViewController () <UITextFieldDelegate>
{
    NSDictionary *_todaysPomodoroDict;
}

-(LSAppDelegate *)appDelegate;
@property NSMutableArray *pomoCycleArray;
@end

@implementation LSToDoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"Work List";
    _todaysPomodoroDict = [self appDelegate].todaysPomodoro;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView setEditing:YES animated:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewCycle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditedList)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)pomoCycleArray
{
    return [[self appDelegate] todaysPomoCycleArray];
}

- (void)createNewCycle
{
    [[self appDelegate] createNewPomoCycle];
    [self.tableView reloadData];
}

-(void)doneEditedList
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


#pragma mark - Table view Display

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.pomoCycleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TASK_IN_CYCLE;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if ([cell.contentView subviews]) {
        for (UIView *subView in [cell.contentView subviews]) {
            [subView removeFromSuperview];
        }
    }
    
    LSPomoCycle *currentSectionPomoCycle = [self.pomoCycleArray objectAtIndex:indexPath.section];
    LSPomoTask *currentTask = [currentSectionPomoCycle.pomoArray objectAtIndex:indexPath.row];

    if ([currentSectionPomoCycle isTaskDone:indexPath.row]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", currentTask.taskName];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    } else {
        cell.textLabel.text = @"";
        UITextField *taskNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 270, 25)];
        taskNameField.delegate = self;
        taskNameField.text = [NSString stringWithFormat:@"%@",currentTask.taskName];
        taskNameField.font = [UIFont boldSystemFontOfSize:17.0];
        taskNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        taskNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cell.contentView addSubview:taskNameField];
        cell.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.backgroundColor = [UIColor darkGrayColor];
    sectionLabel.textColor = [UIColor whiteColor];
    sectionLabel.font = [UIFont boldSystemFontOfSize:12];
    
    sectionLabel.text = [NSString stringWithFormat:@"   Cycle %d",  section+1];
    
    return sectionLabel;
}

#pragma mark - Table view Edit Mode
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; //Default = YES
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


#pragma mark - Table view Row Reorder

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSPomoCycle *currentSectionPomoCycle = [self.pomoCycleArray objectAtIndex:indexPath.section];
    
    if ([currentSectionPomoCycle isTaskStarted:indexPath.row]) {
        return NO;
    }
    
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    LSPomoCycle *toCycle = [self.pomoCycleArray objectAtIndex:proposedDestinationIndexPath.section];
    
    if (proposedDestinationIndexPath.row > [toCycle.pomoArray count]-1) {
        // 섹션의 제일 아래로는 이동이 불가능하고, 다음 섹션 제일 위로만 이동이 가능하게함.
        return sourceIndexPath;
    } else {
        LSPomoTask *toTask = [toCycle.pomoArray objectAtIndex:proposedDestinationIndexPath.row];
        // Done상태 위로는 이동하지 못하도록.
        if (toTask.status > READY) {
            return sourceIndexPath;
        }
    }
    return proposedDestinationIndexPath;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *pomoCycles = self.pomoCycleArray;
    
    LSPomoCycle *toCycle = [pomoCycles objectAtIndex:destinationIndexPath.section];
    LSPomoTask *toTask = [toCycle.pomoArray objectAtIndex:destinationIndexPath.row];
    if (toTask.status > READY) {
        return;
    }

    if (sourceIndexPath.section == destinationIndexPath.section) {
        int fromIndex = sourceIndexPath.row;
        int toIndex = destinationIndexPath.row;
        LSPomoCycle *currentCycle =  [pomoCycles objectAtIndex:sourceIndexPath.section];

        NSMutableArray *newArray = [NSMutableArray arrayWithArray:currentCycle.pomoArray];
        
        [newArray removeObjectAtIndex:fromIndex];
        [newArray insertObject:[currentCycle.pomoArray objectAtIndex:fromIndex] atIndex:toIndex];
        
        currentCycle.pomoArray = newArray;
        
    } else {
        int fromSection = sourceIndexPath.section;
        int toSection = destinationIndexPath.section;
        int fromIndex = sourceIndexPath.row;
        int toIndex = destinationIndexPath.row;
        
        NSMutableArray *oldArray = [[NSMutableArray alloc] initWithCapacity:10];
        for (int section = 0; section < tableView.numberOfSections; section++) {
            LSPomoCycle *cycle = [pomoCycles objectAtIndex:section];
            [oldArray addObjectsFromArray:cycle.pomoArray];
        }
        
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:oldArray];
        [newArray removeObjectAtIndex:(fromSection * TASK_IN_CYCLE + fromIndex)];
        [newArray insertObject:[oldArray objectAtIndex:(fromSection * TASK_IN_CYCLE + fromIndex)] atIndex:(toSection * TASK_IN_CYCLE + toIndex)];
        
        for (int section = 0; section < tableView.numberOfSections; section++) {
            LSPomoCycle *cycle = [pomoCycles objectAtIndex:section];
            NSRange range = NSMakeRange(section * TASK_IN_CYCLE, TASK_IN_CYCLE);
            NSArray *newPomoArray = [newArray subarrayWithRange:range];
            cycle.pomoArray = newPomoArray;
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    else return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSString *newTaskName = textField.text;
    UIView *textFieldView = [textField superview];
    UITableViewCell *cell = (UITableViewCell *)[textFieldView superview];
    NSIndexPath *_editingIndexPath = [self.tableView indexPathForCell:cell];
    
    int pomoIndex = _editingIndexPath.row;
    int currentSection = _editingIndexPath.section;
    
    LSPomoCycle *currentPomoCycle = [self.pomoCycleArray objectAtIndex:currentSection];
    [currentPomoCycle changeTaskName:newTaskName atTaskIndex:pomoIndex];
    [self.pomoCycleArray replaceObjectAtIndex:currentSection withObject:currentPomoCycle];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
