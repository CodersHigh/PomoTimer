//
//  LSHistoryDetailViewController.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 7..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSHistoryDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *historyRecordView;
@property NSDictionary *pomodoroOfTheDay;
@end
