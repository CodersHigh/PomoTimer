//
//  LSViewController.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 30..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property int indexPathRow;

- (IBAction)startPause:(id)sender;
- (IBAction)stop:(id)sender;

@end
