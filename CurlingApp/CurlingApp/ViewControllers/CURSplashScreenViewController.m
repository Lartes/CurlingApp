//
//  CURSplashScreenViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 11/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURSplashScreenViewController.h"

@interface CURSplashScreenViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blueCircle;
@property (nonatomic, strong) UIImageView *redCircle;
@property (nonatomic, strong) UIImageView *curlingTitle;
@property (nonatomic, strong) UIImageView *managerTitle;
@property (nonatomic, strong) UIImageView *firstRedStone;
@property (nonatomic, strong) UIImageView *firstYellowStone;

@end

@implementation CURSplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self startAnimation];
}

- (void)prepareUI
{
    UIImage *image = nil;
    
    image = [UIImage imageNamed:@"background"];
    self.background = [[UIImageView alloc] initWithImage:image];
    self.background.frame = self.view.bounds;
    
    image = [UIImage imageNamed:@"blue_circle"];
    self.blueCircle = [[UIImageView alloc] initWithImage:image];
    self.blueCircle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.blueCircle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)/3.);
    
    image = [UIImage imageNamed:@"red_circle"];
    self.redCircle = [[UIImageView alloc] initWithImage:image];
    self.redCircle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.redCircle.center = self.blueCircle.center;
    
    image = [UIImage imageNamed:@"curling"];
    self.curlingTitle = [[UIImageView alloc] initWithImage:image];
    self.curlingTitle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.curlingTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*2/3.);
    
    image = [UIImage imageNamed:@"manager"];
    self.managerTitle = [[UIImageView alloc] initWithImage:image];
    self.managerTitle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.managerTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*5/6.);
    
    image = [UIImage imageNamed:@"stone_red"];
    self.firstRedStone = [[UIImageView alloc] initWithImage:image];
    self.firstRedStone.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/7., (image.size.height/image.size.width)*(CGRectGetWidth(self.view.frame)/7.));
    self.firstRedStone.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)+CGRectGetHeight(self.firstRedStone.frame));
    
    image = [UIImage imageNamed:@"stone_yellow"];
    self.firstYellowStone = [[UIImageView alloc] initWithImage:image];
    self.firstYellowStone.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/7., (image.size.height/image.size.width)*(CGRectGetWidth(self.view.frame)/7.));
    self.firstYellowStone.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)+CGRectGetHeight(self.firstYellowStone.frame));
    
    self.blueCircle.layer.opacity = 0;
    self.redCircle.layer.opacity = 0;
    self.curlingTitle.layer.opacity = 0;
    self.managerTitle.layer.opacity = 0;
    
    self.blueCircle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.curlingTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.managerTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [self.view addSubview:self.background];
    [self.view addSubview:self.blueCircle];
    [self.view addSubview:self.redCircle];
    [self.view addSubview:self.curlingTitle];
    [self.view addSubview:self.managerTitle];
    [self.view addSubview:self.firstRedStone];
    [self.view addSubview:self.firstYellowStone];
}

- (void)startAnimation
{
    [UIView animateKeyframesWithDuration:4. delay:0. options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        [UIView addKeyframeWithRelativeStartTime:0. relativeDuration:0.1 animations:^{
            self.redCircle.layer.opacity = 1;
            self.redCircle.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.3 animations:^{
            self.redCircle.transform = CGAffineTransformMakeScale(1., 1.);
            self.blueCircle.layer.opacity = 1;
            self.blueCircle.transform = CGAffineTransformMakeScale(1, 1);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.3 animations:^{
            self.curlingTitle.layer.opacity = 1;
            self.curlingTitle.transform = CGAffineTransformMakeScale(1., 1.);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
            self.managerTitle.layer.opacity = 1;
            self.managerTitle.transform = CGAffineTransformMakeScale(1., 1.);
        }];
    } completion:^(BOOL finished){
        [self continueAnimation];
    }];
}

- (void)continueAnimation
{
    CGPoint pointY1 = CGPointMake(CGRectGetWidth(self.view.frame)/5., CGRectGetHeight(self.view.frame)*2./5.);
    CGPoint pointR1 = CGPointMake(pointY1.x+CGRectGetWidth(self.firstRedStone.frame)*cos(0.1), pointY1.y+CGRectGetWidth(self.firstRedStone.frame)*sin(0.1));
    CGPoint pointY2 = CGPointMake(-CGRectGetWidth(self.firstYellowStone.frame), CGRectGetHeight(self.view.frame)/3.);
    CGPoint pointR2 = CGPointMake(self.blueCircle.center.x+10., self.blueCircle.center.y+10.);
    
    CGPoint controlPointForY1 = CGPointMake(CGRectGetWidth(self.view.frame)/10., CGRectGetHeight(self.view.frame)*3./5.);
    CGPoint controlPointForR1 = CGPointMake(CGRectGetWidth(self.view.frame)*3./8., CGRectGetHeight(self.view.frame)*3./5.);
    CGPoint controlPointForY2 = CGPointMake(CGRectGetWidth(self.view.frame)/6., CGRectGetHeight(self.view.frame)/3.);
    CGPoint controlPointForR2 = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*2./5.);
    
    UIBezierPath *pathToR1 = [UIBezierPath bezierPath];
    [pathToR1 moveToPoint:self.firstRedStone.center];
    [pathToR1 addQuadCurveToPoint:pointR1 controlPoint:controlPointForR1];
    UIBezierPath *pathToR2 = [UIBezierPath bezierPath];
    [pathToR2 moveToPoint:pointR1];
    [pathToR2 addQuadCurveToPoint:pointR2 controlPoint:controlPointForR2];
    
    UIBezierPath *pathToY1 = [UIBezierPath bezierPath];
    [pathToY1 moveToPoint:self.firstYellowStone.center];
    [pathToY1 addQuadCurveToPoint:pointY1 controlPoint:controlPointForY1];
    UIBezierPath *pathToY2 = [UIBezierPath bezierPath];
    [pathToY2 moveToPoint:pointY1];
    [pathToY2 addQuadCurveToPoint:pointY2 controlPoint:controlPointForY2];
    
    CAKeyframeAnimation *animatedPathToY1 = [CAKeyframeAnimation animation];
    animatedPathToY1.keyPath = @"position";
    animatedPathToY1.path = pathToY1.CGPath;
    animatedPathToY1.duration = 3.;
    animatedPathToY1.beginTime = 0.;
    animatedPathToY1.fillMode = @"forwards";
    animatedPathToY1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animatedPathToY1.rotationMode = kCAAnimationRotateAuto;
    
    CAKeyframeAnimation *animatedPathToY2 = [CAKeyframeAnimation animation];
    animatedPathToY2.keyPath = @"position";
    animatedPathToY2.path = pathToY2.CGPath;
    animatedPathToY2.duration = 1.;
    animatedPathToY2.beginTime = 4.;
    animatedPathToY2.fillMode = @"forwards";
    animatedPathToY2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animatedPathToY2.rotationMode = kCAAnimationRotateAuto;
    
    CAAnimationGroup *yellowStonePath = [CAAnimationGroup animation];
    yellowStonePath.animations = @[animatedPathToY1, animatedPathToY2];
    yellowStonePath.duration = 5.5;
    [self.firstYellowStone.layer addAnimation:yellowStonePath forKey:@"yellow"];
    
    CAKeyframeAnimation *animatedPathToR1 = [CAKeyframeAnimation animation];
    animatedPathToR1.keyPath = @"position";
    animatedPathToR1.path = pathToR1.CGPath;
    animatedPathToR1.duration = 2.;
    animatedPathToR1.beginTime = 2.;
    animatedPathToR1.fillMode = @"forwards";
    animatedPathToR1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatedPathToR1.rotationMode = kCAAnimationRotateAuto;
    
    CAKeyframeAnimation *animatedPathToR2 = [CAKeyframeAnimation animation];
    animatedPathToR2.keyPath = @"position";
    animatedPathToR2.path = pathToR2.CGPath;
    animatedPathToR2.duration = 1.5;
    animatedPathToR2.beginTime = 4.;
    animatedPathToR2.fillMode = @"forwards";
    animatedPathToR2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animatedPathToR2.rotationMode = kCAAnimationRotateAuto;
    
    CAAnimationGroup *redStonePath = [CAAnimationGroup animation];
    redStonePath.animations = @[animatedPathToR1, animatedPathToR2];
    redStonePath.duration = 5.5;
    redStonePath.delegate = self;
    [self.firstRedStone.layer addAnimation:redStonePath forKey:@"red"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CURGamesTableViewController *gamesTableViewController = [CURGamesTableViewController new];
    UINavigationController *gameNavigationController = [[UINavigationController alloc] initWithRootViewController:gamesTableViewController];
    gameNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:gameNavigationController animated:YES completion:nil];
}


@end
