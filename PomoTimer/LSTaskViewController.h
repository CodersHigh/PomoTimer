//
//  LSTaskViewController.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *taskView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)startPause:(id)sender;
- (IBAction)reset:(id)sender;

@property NSDictionary *todaysPomodoroDict;

@end
