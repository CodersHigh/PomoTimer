//
//  NumberPushingView.h
//  PomoTimer
//
//  Created by LingoStar on 13. 01. 02.
//  Copyright 2013 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LSNumberPushingView : UIView

@property int numType;
@property int targetPanelNum;
@property int maxNum;

- (id)initWithFrame:(CGRect)frame numType:(int)numType;

#define TIMER_NUM 0
#define CYCLE_NUM 1
@end

