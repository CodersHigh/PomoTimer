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

- (void)resetCurrentTask;
- (int)doneTaskCount;
- (int)startedTaskCount;

- (BOOL)isTaskDone:(int)index;
- (BOOL)isTaskStarted:(int)index;
- (void)changeTaskName:(NSString *)newName atTaskIndex:(int)index;

@property NSArray *pomoArray;
@property NSArray *recessArray;

@property LSPomoTask *currentTask;

@end
