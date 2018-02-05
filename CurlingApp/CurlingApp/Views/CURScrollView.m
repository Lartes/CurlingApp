//
//  CURScrollView.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScrollView.h"

@implementation CURScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchCoord = [touch locationInView:self];
    UIView *touchView = touch.view;
    [self.output touchHappendAtCoord:touchCoord onView:touchView];
    NSLog(@"касание идет c координатами x = %f, y = %f", touchCoord.x, touchCoord.y);
}

@end
