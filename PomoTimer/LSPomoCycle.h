//
//  LSPomoCycle.h
//  PomoTimer
//
//  Created by Lingostar on 12. 12. 31..
//  Copyright (c) 2012년 Lingostar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSPomoTask.h"

@interface LSPomoCycle : NSObject

- (id)initWithType:(int)typeOfCycle;

@property NSArray *taskArray;
@property LSPomoTask *currentTask;
@property int typeOfCycle;
//0 25Pomodoro & 5Recess
//1 25P & 5R & 25P & 5R
//2 25P & 5R & 25P & 5R & 25P & 5R
//3 25P & 5R & 25P & 5R & 25P & 5R & 25P & 30I

@end
