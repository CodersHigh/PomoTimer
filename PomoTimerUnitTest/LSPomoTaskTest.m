//
//  LSPomoTaskTest.m
//  PomoTimer
//
//  Created by Lingostar on 13. 7. 9..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSPomoTaskTest.h"

@interface LSPomoTaskTest () {
    LSPomoTask *_task;
}

@end
@implementation LSPomoTaskTest

- (void)setUp
{
    [super setUp];
    
    _task = [[LSPomoTask alloc] init];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


-(void)testIsReadyAtInit {
    //최초 실행 시 READY상태인지 테스트
    STAssertEquals(_task.status, READY, @"Initial Not READY");

}

-(void)testDate{
    //StartDate와 EndDate가 제대로 입력되는지 테스트
    

    
}

-(void)testDone{
    //TaskTimeInSecond==0 일때 상태가 Done인지 테스트

    
    _task.status = COUNTING;
    
    _task.taskTimeInSecond = 3;
    

    for (int i=0; i<4; i++) {
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
    }

    NSLog(@"taskTimeInSecond : %d", _task.taskTimeInSecond);
    
    
    STAssertEquals(_task.status, DONE, @"뽀모도로가 끝났지만 상태가 Done 아님.");



}

-(void)testChangeStatus{
    //상태값 입력이 제대로 되는지 테스트
    //READY
    //COUNTING
    //PAUSE
    //DONE
}

-(void)testTimeCountDown{
    //status가 COUNTING일 때 taskTimeInSecond가 내려가는지 테스트
    
    _task.status = COUNTING;

    int oldSecond = _task.taskTimeInSecond;
    
    //sleep(2000);
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0f]];
    int newSecond = _task.taskTimeInSecond;

    if (oldSecond <= newSecond ) {
        STFail(@"Counting 중인데 taskTimeInSecond가 내려가지 않음.");
    }
    
}

-(void)testReset {
    //reset이 되었는지 테스트
    _task.status = COUNTING;
    
    //시간 보내고
    
    [_task resetTask];
    
    int taskTime = _task.taskTimeInSecond;
    int status = _task.status;
    NSTimer *timer = [_task pomodoroTimer];
    
    STAssertEquals(taskTime, POMODORO_TIME, @"Reset을 요청했으나 taskTimeInSecond가 처음으로 되돌아가지 않음.");
    STAssertEquals(status, READY, @"Reset을 요청했으나 Status가 Ready가 아님.");
    STAssertNil(timer, @"Reset을 요청했으나 Timer가 Nil이 아님.");
    
}




@end
