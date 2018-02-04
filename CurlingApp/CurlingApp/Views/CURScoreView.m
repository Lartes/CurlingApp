//
//  CURScoreView.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScoreView.h"

static const CGFloat STONESIZE = 15.;

@interface CURScoreView ()

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UIView *redStone;
@property (nonatomic, strong) UIView *yellowStone;
@property (nonatomic, assign) NSInteger redScore;
@property (nonatomic, assign) NSInteger yellowScore;

@end

@implementation CURScoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _redScore = 8;
        _yellowScore = 8;
        
        _score = [[UILabel alloc]initWithFrame:CGRectZero];
        _score.text = @"8:8";
        _score.textAlignment = NSTextAlignmentCenter;
        _score.textColor = [UIColor blackColor];
        [self addSubview:_score];
        
        _redStone = [[UIView alloc] initWithFrame:CGRectMake(0,0,STONESIZE,STONESIZE)];
        _redStone.layer.cornerRadius = STONESIZE/2.;
        _redStone.backgroundColor = [UIColor redColor];
        [self addSubview:_redStone];
        
        _yellowStone = [[UIView alloc] initWithFrame:CGRectMake(0,0,STONESIZE,STONESIZE)];
        _yellowStone.layer.cornerRadius = STONESIZE/2.;
        _yellowStone.backgroundColor = [UIColor yellowColor];
        [self addSubview:_yellowStone];
    }
    return self;
}

- (void)layoutSubviews
{
    self.score.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)-STONESIZE*2, CGRectGetHeight(self.frame));
    self.score.center = self.center;
    self.redStone.center = CGPointMake(STONESIZE/2., CGRectGetHeight(self.frame)/2.);
    self.yellowStone.center = CGPointMake(CGRectGetWidth(self.frame)-STONESIZE/2., CGRectGetHeight(self.frame)/2.);
}

#pragma mark - CURChangeScoreProtocol

- (void)changeScoreForColor:(UIColor *)color
{
    if (color==[UIColor redColor])
    {
        self.redScore -= 1;
        self.score.text = [NSString stringWithFormat:@"%ld:%ld", self.redScore, self.yellowScore];
    }
    else
    {
        self.yellowScore -= 1;
        self.score.text = [NSString stringWithFormat:@"%ld:%ld", self.redScore, self.yellowScore];
    }
}

@end
