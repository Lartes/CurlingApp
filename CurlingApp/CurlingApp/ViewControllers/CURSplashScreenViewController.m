//
//  CURSplashScreenViewController.m
//  CurlingApp
//
//  Created by Artem Lomov on 11/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURSplashScreenViewController.h"

@interface CURSplashScreenViewController ()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blueCircle;
@property (nonatomic, strong) UIImageView *redCircle;
@property (nonatomic, strong) UIImageView *curlingTitle;
@property (nonatomic, strong) UIImageView *managerTitle;
@property (nonatomic, strong) UIImageView *firstRedStone;
@property (nonatomic, strong) UIImageView *firstYellowStone;
@property (nonatomic, strong) CURStoneAnimationController *stoneAnumation;

@end

@implementation CURSplashScreenViewController


#pragma mark - Lifecycle

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
    self.blueCircle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                       (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.blueCircle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)/3.);
    
    image = [UIImage imageNamed:@"red_circle"];
    self.redCircle = [[UIImageView alloc] initWithImage:image];
    self.redCircle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                      (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.redCircle.center = self.blueCircle.center;
    
    image = [UIImage imageNamed:@"curling"];
    self.curlingTitle = [[UIImageView alloc] initWithImage:image];
    self.curlingTitle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                         (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.curlingTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*2/3.);
    
    image = [UIImage imageNamed:@"manager"];
    self.managerTitle = [[UIImageView alloc] initWithImage:image];
    self.managerTitle.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),
                                         (image.size.height/image.size.width)*CGRectGetWidth(self.view.frame));
    self.managerTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2., CGRectGetHeight(self.view.frame)*5/6.);
    
    image = [UIImage imageNamed:@"stone_red"];
    self.firstRedStone = [[UIImageView alloc] initWithImage:image];
    self.firstRedStone.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/7.,
                                          (image.size.height/image.size.width)*(CGRectGetWidth(self.view.frame)/7.));
    self.firstRedStone.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.,
                                            CGRectGetHeight(self.view.frame)+CGRectGetHeight(self.firstRedStone.frame));
    
    image = [UIImage imageNamed:@"stone_yellow"];
    self.firstYellowStone = [[UIImageView alloc] initWithImage:image];
    self.firstYellowStone.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/7.,
                                             (image.size.height/image.size.width)*(CGRectGetWidth(self.view.frame)/7.));
    self.firstYellowStone.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.,
                                               CGRectGetHeight(self.view.frame)+CGRectGetHeight(self.firstYellowStone.frame));
    
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
    
    self.stoneAnumation = [[CURStoneAnimationController alloc] initWithView:self.view
                                                                 firstStone:self.firstYellowStone
                                                                secondStone:self.firstRedStone];
    self.stoneAnumation.output = self;
}


#pragma mark - Animation Actions

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
        [self.stoneAnumation runStoneAnimationToPoint:CGPointMake(self.blueCircle.center.x+10., self.blueCircle.center.y+10.)];
    }];
}


#pragma mark - CURStoneAnimationProtocol

- (void)animationEnded
{
    CURGamesTableViewController *gamesTableViewController = [CURGamesTableViewController new];
    gamesTableViewController.coreDataManager = self.coreDataManager;
    UINavigationController *gameNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:gamesTableViewController];
    gameNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:gameNavigationController animated:YES completion:nil];
}

@end
