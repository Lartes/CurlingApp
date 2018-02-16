//
//  CURScrollView.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScrollView.h"

@implementation CURScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    if (touch.view!=self)
    {
        self.scrollEnabled = NO;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.scrollEnabled = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchCoord = [touch locationInView:self];
    touchCoord = CGPointMake(MIN(MAX(touchCoord.x, 0), CGRectGetWidth(self.frame)),
                             MIN(MAX(touchCoord.y, 0), CGRectGetHeight(self.frame)));
    UIView *touchView = touch.view;
    [self.output touchHappendAtCoord:touchCoord onView:touchView];
}

@end
