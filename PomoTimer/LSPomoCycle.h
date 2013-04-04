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

@property NSArray *taskArray;
@property LSPomoTask *currentTask;

@end
