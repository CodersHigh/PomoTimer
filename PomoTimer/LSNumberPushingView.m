//
//  NumberPushingView.m
//  PomoTimer
//
//  Created by LingoStar on 13. 01. 02.
//  Copyright 2013 Lingostar. All rights reserved.
//

#import "LSNumberPushingView.h"

@interface LSNumberPushingView()
{
	UIView *_panelNumContainerView;
	UIImageView *_nextPanelImageView;
}

- (void)pushPanelFrom:(int)fromValue to:(int)toValue;

@end

@implementation LSNumberPushingView

- (id)initWithFrame:(CGRect)frame numType:(int)numType
{
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        self.numType = numType;
        
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _panelNumContainerView = [[UIView alloc] initWithFrame:bounds];
        [self addSubview:_panelNumContainerView];
        
        _nextPanelImageView = [[UIImageView alloc] initWithFrame:bounds];
        [_panelNumContainerView addSubview:_nextPanelImageView];
        
        
        _targetPanelNum = -1;
        _maxNum = 9;
        [self addObserver:self forKeyPath:@"targetPanelNum"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        self.targetPanelNum = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numType:TIMER_NUM];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int oldValue = [[change valueForKey:NSKeyValueChangeOldKey] intValue];
    int newValue = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
    
    
	if (oldValue != newValue) {
         [self pushPanelFrom:oldValue to:newValue];
    }
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"targetPanelNum"];
}


- (void)pushPanelFrom:(int)fromValue to:(int)toValue
{
	CATransition *animation = [CATransition animation];
	animation.duration = 0.2;
	animation.type = kCATransitionPush;
    
	if (fromValue == _maxNum && toValue ==0){
		animation.subtype = kCATransitionFromTop;
	} else if (fromValue ==0 && toValue ==_maxNum){
		animation.subtype = kCATransitionFromBottom;
	} else {
		if (fromValue < toValue)
			animation.subtype = kCATransitionFromTop;
		else 
			animation.subtype = kCATransitionFromBottom;
	}
	[_nextPanelImageView removeFromSuperview];
	
	NSString *imageName;
    
    if(self.numType == TIMER_NUM)
        imageName = [NSString stringWithFormat:@"num_%d.png", toValue];
    else if(self.numType == CYCLE_NUM)
        imageName = [NSString stringWithFormat:@"cycle_%d.png", toValue];
    
    
	UIImage *newImage = [UIImage imageNamed:imageName];
	_nextPanelImageView.image = newImage;
	
	[_panelNumContainerView addSubview:_nextPanelImageView];
	
	[_panelNumContainerView.layer addAnimation:animation forKey:@"transitionViewAnimation"];
}

@end
