//
//  LSTimerButton.m
//  PomoTimer
//
//  Created by Lingostar on 13. 2. 12..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSTimerButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ColorAtPixel.h"


@interface LSTimerButton ()
{
    UIImageView *_progressPoint;
    UIImageView *_timerPanel;
    UIImageView *_playPauseImage;
    UILabel *_timeLabel;
    
    float _rotateAngle;
}
@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL previousTouchHitTestResponse;
@end

@implementation LSTimerButton
@synthesize previousTouchPoint = _previousTouchPoint;
@synthesize previousTouchHitTestResponse = _previousTouchHitTestResponse;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setUpTimer];

        _rotateAngle = 0;        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotatePointWithPomodoro:) name:kPomodoroTimeChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(labelUpdate:) name:kPomodoroTimeChanged object:nil];
   }
    
    return self;
}

- (void)setUpTimer
{
    CGRect bounds = self.bounds;
    CGPoint center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    

    _timerPanel = [[UIImageView alloc] initWithFrame:bounds];
    [_timerPanel setImage:[UIImage imageNamed:@"panel_default"]];
    [_timerPanel setContentMode:UIViewContentModeScaleAspectFit];
    [_timerPanel setCenter:center];

    [self addSubview:_timerPanel];


    
    _progressPoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"point_black"]];
    _progressPoint.contentMode = UIViewContentModeScaleAspectFit;
    CGSize pointSize = _progressPoint.bounds.size;
    _progressPoint.frame = CGRectMake(center.x-(pointSize.width/2), center.y-(pointSize.height/2), pointSize.width, pointSize.height);
    _progressPoint.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self addSubview:_progressPoint];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 170, 150, 40)];
    _timeLabel.text=@"25:00";
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _timeLabel.textColor=[UIColor colorWithWhite:0.8 alpha:1];
    _timeLabel.font=[UIFont systemFontOfSize:50.0];
    [self addSubview:_timeLabel];

    _playPauseImage = [[UIImageView alloc] initWithFrame:CGRectMake(135, 95, 60, 60)];
    _playPauseImage.image = [UIImage imageNamed:@"status_play"];
    [self addSubview:_playPauseImage];
}

-(void)rotatePointWithPomodoro:(NSNotification *)notification
{
    LSPomoTask *currentTask;
    if (notification != nil) {
        currentTask = [notification object];
    }
    
    if (currentTask.typeOfTask == POMODORO) {
        
        float taskTime = (float)currentTask.taskTimeInSecond;
        float pomoTime = (float)POMODORO_TIME;
        float unitValue = taskTime / pomoTime;
        float currentAngle = - unitValue * M_PI *2;
        CATransform3D rotationTransform = CATransform3DMakeRotation(currentAngle, 0.0, 0.0, 1.0);
        _progressPoint.layer.transform = rotationTransform;

    } else if (currentTask.typeOfTask == RECESS) {
        _progressPoint.layer.transform = CATransform3DMakeRotation(0.0, 0.0, 0.0, 1.0);
    }
    
    
}


-(void)updateTimerImage:(LSPomoTask *)currentTask
{
    int pomoType = currentTask.typeOfTask;
    int pomoStatus = currentTask.status;
    
    [self updatePointImage:pomoType status:pomoStatus];
    [self updateTimerColor:pomoType status:pomoStatus];
    [self updateStateImage:pomoStatus];
}

-(void)updatePointImage:(int)pomoType status:(int)pomoStatus
{

    if (pomoType == POMODORO && pomoStatus == COUNTING) {
        _progressPoint.image = [UIImage imageNamed:@"point_red"];
    } else {
        _progressPoint.image = [UIImage imageNamed:@"point_black"];
    }
        
}
-(void)updateTimerColor:(int)pomoType status:(int)pomoStatus
{

    if (pomoType == POMODORO) {
        switch (pomoStatus) {
            case PAUSE :
                _timerPanel.image = [UIImage imageNamed:@"panel_pomo_pause"];
                break;
            default:
                _timerPanel.image = [UIImage imageNamed:@"panel_default"];
                break;
        }
    } else if (pomoType == RECESS) {
      _timerPanel.image = [UIImage imageNamed:@"panel_recess"];
    }
    
    
}

-(void)updateStateImage:(int)pomoStatus
{
    switch (pomoStatus) {
        case COUNTING:
            _playPauseImage.image = [UIImage imageNamed:@"status_pause"];
            break;
            
        default:
            _playPauseImage.image = [UIImage imageNamed:@"status_play"];
            break;
    }

}

- (void)labelUpdate:(NSNotification *)notification
{
    LSPomoTask *currentTask;
    if (notification != nil) {
        currentTask = [notification object];
    }
    
    int timesLeft = currentTask.taskTimeInSecond;
    int taskMinute = timesLeft/60;
    int taskSecond = timesLeft%60;
    
    NSString *timeString = [NSString stringWithFormat:@"%.2d:%.2d", taskMinute, taskSecond];
    _timeLabel.text = timeString;
}

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image
{
    // Correct point to take into account that the image does not have to be the same size
    // as the button. See https://github.com/ole/OBShapedButton/issues/1
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;
    
    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {// available from iOS 5.0
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    else
    {// for iOS < 5.0
        // In iOS 6.1 the code is not working in release mode, it works only in debug
        // CGColorGetAlpha always return 0.
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return alpha >= 0.1f;
}


// UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
// If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
// of the view hierarchy is ignored.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
    // Don't check again if we just queried the same point
    // (because pointInside:withEvent: gets often called multiple times)
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }
    
    // We can't test the image's alpha channel if the button has no image. Fall back to super.
    UIImage *buttonImage = _timerPanel.image;
    
    
    BOOL response = NO;
    
    if (buttonImage == nil) {
        response = YES;
    }
    else if (buttonImage != nil) {
        response = [self isAlphaVisibleAtPoint:point forImage:buttonImage];
    }
    
    
    self.previousTouchHitTestResponse = response;
    return response;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
