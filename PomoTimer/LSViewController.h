//
//  LSViewController.h
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 14..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSViewController : UIViewController
- (IBAction)startPause:(id)sender;
- (IBAction)stop:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end
