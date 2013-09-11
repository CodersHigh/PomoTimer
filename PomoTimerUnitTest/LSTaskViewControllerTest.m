//
//  LSTaskViewControllerTest.m
//  PomoTimer
//
//  Created by wookchu on 13. 7. 15..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSTaskViewControllerTest.h"

@interface LSTaskViewControllerTest () {
    LSPomoCycle *_cycle;
    LSTaskViewController *_vc;
}

@end

@implementation LSTaskViewControllerTest

-(void)setUp {
    [super setUp];
    
    _vc = [[LSTaskViewController alloc] init];
    _cycle = _vc.pomoCycle;
}
-(void)tearDown {
    [super tearDown];
}

-(void)testNewTaskInCycle {
    //Cycle 내에서 Task가 끝났을 때 새로운 Task로 진행이 되는지 테스트

    NSMutableArray *taskArray = [NSMutableArray array];
    
    for (int i=0; i<4; i++) {
        [taskArray addObject:[_cycle.pomoArray objectAtIndex:i]];
        [taskArray addObject:[_cycle.recessArray objectAtIndex:i]];
    }

      
    for (int i=0; i<taskArray.count-1; i++) {
        LSPomoTask *oldTask = [taskArray objectAtIndex:i];
        oldTask.status = DONE;

        LSPomoTask *newTask = [taskArray objectAtIndex:i+1];
        
        STAssertEquals(newTask.status, COUNTING, @"한 Task가 끝났지만 다음 Task가 COUNTING되지 않음.");
    }
    

}
-(void)testNewCycleAtCycleDone {
    //Cycle의 PomoTask가 모두 Done일때 올라갔을 때 새로운 싸이클이 생성되는지 테스트
    
    for (int i=0; i<4; i++) {
        LSPomoTask *pomoTask = [_cycle.pomoArray objectAtIndex:i];
        LSPomoTask *recessTask = [_cycle.recessArray objectAtIndex:i];
        pomoTask.status = DONE;
        recessTask.status = DONE;
    }
    
    LSPomoTask *newTask = _cycle.currentTask;
    LSPomoTask *firstTask = [_cycle.pomoArray objectAtIndex:0];
    
    if (newTask.status == DONE || [newTask isEqual:firstTask]) {
        STFail(@"PomoTask가 모두 Done 일 때 새로운 사이클이 생성되지 않음.");
    }
    

}

-(void)testStatusCountingInNextCycle {
    //새로운 사이클이 생겼을 때 task의 상태가 Counting이 되는지 테스트
    for (int i=0; i<4; i++) {
        LSPomoTask *pomoTask = [_cycle.pomoArray objectAtIndex:i];
        LSPomoTask *recessTask = [_cycle.recessArray objectAtIndex:i];
        pomoTask.status = DONE;
        recessTask.status = DONE;
    }
    
    int status = _cycle.currentTask.status;
    
    STAssertEquals(status, COUNTING, @"새로운 사이클이 생겼을 때 Task 상태가 COUNTING이 아님.");
    
}



@end
