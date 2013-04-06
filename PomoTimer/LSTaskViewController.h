//
//  LSTaskViewController.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *taskScrollView;
@property NSDictionary *todaysPomodoroDict;

@end
