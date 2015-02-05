//
//  UITextFieldNoLongPress.m
//  MyWeatherApp
//
//  Created by osama mourad on 12/21/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "UITextFieldNoLongPress.h"

@implementation UITextFieldNoLongPress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = NO;
    }
    [super addGestureRecognizer:gestureRecognizer];
    return;
}

@end
