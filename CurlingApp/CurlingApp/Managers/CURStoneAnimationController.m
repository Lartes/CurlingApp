//
//  CURStoneAnimationController.m
//  CurlingApp
//
//  Created by Artem Lomov on 17/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURStoneAnimationController.h"

@interface CURStoneAnimationController () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *firstStone;
@property (nonatomic, strong) UIView *secondStone;

@end

@implementation CURStoneAnimationController

- (instancetype)initWithView:(UIView *)view firstStone:(UIView *)firstStone secondStone:(UIView *)secondStone
{
    self = [super init];
    if (self)
    {
        _view = view;
        _firstStone = firstStone;
        _secondStone = secondStone;
    }
    return self;
}

- (CAKeyframeAnimation *)makeAnimationWithPath:(CGPathRef)path
                                      duration:(CFTimeInterval)duration
                                     beginTime:(CFTimeInterval)beginTime
                                timingFunction:(NSString *)timingFunction
{
    CAKeyframeAnimation *animatedPath = [CAKeyframeAnimation animation];
    animatedPath.keyPath = @"position";
    animatedPath.path = path;
    animatedPath.duration = duration;
    animatedPath.beginTime = beginTime;
    animatedPath.fillMode = @"forwards";
    animatedPath.timingFunction = [CAMediaTimingFunction functionWithName:timingFunction];
    animatedPath.rotationMode = kCAAnimationRotateAuto;
    return animatedPath;
}

- (void)runStoneAnimationToPoint:(CGPoint)endPoint
{
    CGPoint pointY1 = CGPointMake(CGRectGetWidth(self.view.frame)/5., CGRectGetHeight(self.view.frame)*2./5.);
    CGPoint pointR1 = CGPointMake(pointY1.x+CGRectGetWidth(self.secondStone.frame)*cos(0.1),
                                  pointY1.y+CGRectGetWidth(self.secondStone.frame)*sin(0.1));
    CGPoint pointY2 = CGPointMake(-CGRectGetWidth(self.firstStone.frame), CGRectGetHeight(self.view.frame)/3.);
    CGPoint pointR2 = endPoint;
    
    CGPoint controlPointForY1 = CGPointMake(CGRectGetWidth(self.view.frame)/10., CGRectGetHeight(self.view.frame)*3./5.);
    CGPoint controlPointForR1 = CGPointMake(CGRectGetWidth(self.view.frame)*3./8., CGRectGetHeight(self.view.frame)*3./5.);
    CGPoint controlPointForY2 = CGPointMake(CGRectGetWidth(self.view.frame)/6., CGRectGetHeight(self.view.frame)/3.);
    CGPoint controlPointForR2 = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*2./5.);
    
    UIBezierPath *pathToR1 = [UIBezierPath bezierPath];
    [pathToR1 moveToPoint:self.secondStone.center];
    [pathToR1 addQuadCurveToPoint:pointR1 controlPoint:controlPointForR1];
    UIBezierPath *pathToR2 = [UIBezierPath bezierPath];
    [pathToR2 moveToPoint:pointR1];
    [pathToR2 addQuadCurveToPoint:pointR2 controlPoint:controlPointForR2];
    
    UIBezierPath *pathToY1 = [UIBezierPath bezierPath];
    [pathToY1 moveToPoint:self.firstStone.center];
    [pathToY1 addQuadCurveToPoint:pointY1 controlPoint:controlPointForY1];
    UIBezierPath *pathToY2 = [UIBezierPath bezierPath];
    [pathToY2 moveToPoint:pointY1];
    [pathToY2 addQuadCurveToPoint:pointY2 controlPoint:controlPointForY2];
    
    CAKeyframeAnimation *animatedPathToY1 = [self makeAnimationWithPath:pathToY1.CGPath
                                                               duration:3.
                                                              beginTime:0.
                                                         timingFunction:kCAMediaTimingFunctionEaseOut];
    CAKeyframeAnimation *animatedPathToY2 = [self makeAnimationWithPath:pathToY2.CGPath
                                                               duration:1.
                                                              beginTime:4.
                                                         timingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *firstStonePath = [CAAnimationGroup animation];
    firstStonePath.animations = @[animatedPathToY1, animatedPathToY2];
    firstStonePath.duration = 5.5;
    [self.firstStone.layer addAnimation:firstStonePath forKey:@"yellow"];
    
    CAKeyframeAnimation *animatedPathToR1 = [self makeAnimationWithPath:pathToR1.CGPath
                                                               duration:2.
                                                              beginTime:2.
                                                         timingFunction:kCAMediaTimingFunctionEaseIn];
    CAKeyframeAnimation *animatedPathToR2 = [self makeAnimationWithPath:pathToR2.CGPath
                                                               duration:1.5
                                                              beginTime:4.
                                                         timingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *secondStonePath = [CAAnimationGroup animation];
    secondStonePath.animations = @[animatedPathToR1, animatedPathToR2];
    secondStonePath.duration = 5.5;
    secondStonePath.delegate = self;
    [self.secondStone.layer addAnimation:secondStonePath forKey:@"red"];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.output animationEnded];
}

@end
