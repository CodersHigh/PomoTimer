//
//  LSHistoryListViewController.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 6..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSHistoryListViewController.h"
#import "LSAppDelegate.h"
#import "LSHistoryDetailViewController.h"

@interface LSHistoryListViewController ()

- (LSAppDelegate *)appDelegate;
@end

@implementation LSHistoryListViewController

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"History";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfHistory = [[self appDelegate].dailyPomodoroArray count];
    return numberOfHistory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dailyPomodoro = [[self appDelegate].dailyPomodoroArray objectAtIndex:indexPath.row];
    NSDate *pomodoroDate = [dailyPomodoro valueForKey:kPomodoroDateKey];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy년 MM월dd일의 작업"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"KST"]];
    
    cell.textLabel.text = [dateFormatter stringFromDate:pomodoroDate];
    
    NSArray *pomoCycleArray = [dailyPomodoro valueForKey:kPomodoroCyclesKey];
    LSPomoCycle *currentCycle = [pomoCycleArray lastObject];
    int dailyCycle, dailyTimes, dailyTotal;
    dailyCycle = [pomoCycleArray count] - 1;
    dailyTimes = [currentCycle doneTaskCount];
    dailyTotal = dailyCycle*4 + dailyTimes;
    NSString *cycleString = [NSString stringWithFormat:@"%d Cycle %d Times , Total %d Pomodoro", dailyCycle, dailyTimes, dailyTotal];
    cell.detailTextLabel.text  = cycleString;
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LSHistoryDetailViewController *destController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *dailyPomodoro = [[self appDelegate].dailyPomodoroArray objectAtIndex:indexPath.row];
    destController.pomodoroOfTheDay = dailyPomodoro;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

    //LSHistoryDetailViewController *detailViewController = [[LSHistoryDetailViewController alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:detailViewController animated:YES];
}


@end
