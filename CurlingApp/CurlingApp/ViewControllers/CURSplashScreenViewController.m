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
        CGPoint Y1 = CGPointMake(CGRectGetWidth(self.view.frame)/5., CGRectGetHeight(self.view.frame)*2./5.);
        CGPoint R1 = CGPointMake(Y1.x+CGRectGetWidth(self.firstRedStone.frame)*cos(0.1), Y1.y+CGRectGetWidth(self.firstRedStone.frame)*sin(0.1));
        CGPoint Y2 = CGPointMake(-CGRectGetWidth(self.firstYellowStone.frame), CGRectGetHeight(self.view.frame)/3.);
        CGPoint R2 = CGPointMake(self.blueCircle.center.x+10., self.blueCircle.center.y+10.);
        
        CGPoint Y1C = CGPointMake(CGRectGetWidth(self.view.frame)/10., CGRectGetHeight(self.view.frame)*3./5.);
        CGPoint R1C = CGPointMake(CGRectGetWidth(self.view.frame)*3./8., CGRectGetHeight(self.view.frame)*3./5.);
        CGPoint Y2C = CGPointMake(CGRectGetWidth(self.view.frame)/6., CGRectGetHeight(self.view.frame)/3.);
        CGPoint R2C = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*2./5.);
        
        UIBezierPath *pathR1 = [UIBezierPath bezierPath];
        [pathR1 moveToPoint:self.firstRedStone.center];
        [pathR1 addQuadCurveToPoint:R1 controlPoint:R1C];
        UIBezierPath *pathR2 = [UIBezierPath bezierPath];
        [pathR2 moveToPoint:R1];
        [pathR2 addQuadCurveToPoint:R2 controlPoint:R2C];
        
        UIBezierPath *pathY1 = [UIBezierPath bezierPath];
        [pathY1 moveToPoint:self.firstYellowStone.center];
        [pathY1 addQuadCurveToPoint:Y1 controlPoint:Y1C];
        UIBezierPath *pathY2 = [UIBezierPath bezierPath];
        [pathY2 moveToPoint:Y1];
        [pathY2 addQuadCurveToPoint:Y2 controlPoint:Y2C];
        
        CAKeyframeAnimation *animationY1 = [CAKeyframeAnimation animation];
        animationY1.keyPath = @"position";
        animationY1.path = pathY1.CGPath;
        animationY1.duration = 3.;
        animationY1.beginTime = 0.;
        animationY1.fillMode = @"forwards";
        animationY1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationY1.rotationMode = kCAAnimationRotateAuto;
        
        CAKeyframeAnimation *animationY2 = [CAKeyframeAnimation animation];
        animationY2.keyPath = @"position";
        animationY2.path = pathY2.CGPath;
        animationY2.duration = 1.;
        animationY2.beginTime = 4.;
        animationY2.fillMode = @"forwards";
        animationY2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationY2.rotationMode = kCAAnimationRotateAuto;
        
        CAAnimationGroup *groupY = [CAAnimationGroup animation];
        groupY.animations = @[animationY1, animationY2];
        groupY.duration = 5.5;
        [self.firstYellowStone.layer addAnimation:groupY forKey:@"yellow"];
        
        CAKeyframeAnimation *animationR1 = [CAKeyframeAnimation animation];
        animationR1.keyPath = @"position";
        animationR1.path = pathR1.CGPath;
        animationR1.duration = 2.;
        animationR1.beginTime = 2.;
        animationR1.fillMode = @"forwards";
        animationR1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animationR1.rotationMode = kCAAnimationRotateAuto;
        
        CAKeyframeAnimation *animationR2 = [CAKeyframeAnimation animation];
        animationR2.keyPath = @"position";
        animationR2.path = pathR2.CGPath;
        animationR2.duration = 1.5;
        animationR2.beginTime = 4.;
        animationR2.fillMode = @"forwards";
        animationR2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationR2.rotationMode = kCAAnimationRotateAuto;
        
        CAAnimationGroup *groupR = [CAAnimationGroup animation];
        groupR.animations = @[animationR1, animationR2];
        groupR.duration = 5.5;
        groupR.delegate = self;
        [self.firstRedStone.layer addAnimation:groupR forKey:@"red"];
    }];
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
