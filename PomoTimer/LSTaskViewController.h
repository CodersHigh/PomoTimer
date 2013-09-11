//
//  LSTaskViewController.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSPomoCycle;
@class LSTimerButton;
@interface LSTaskViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *taskScrollView;
@property NSDictionary *todaysPomodoroDict;
@property LSPomoCycle *pomoCycle;

-(LSTimerButton *)pomoTimerButton;
@end
