//
//  CURScoreView.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScoreView.h"

static const CGFloat STONESIZE = 30.;

@interface CURScoreView ()

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UIImageView *redStone;
@property (nonatomic, strong) UIImageView *yellowStone;
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
        _score.font = [UIFont systemFontOfSize:20];
        [self addSubview:_score];
        
        _redStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,STONESIZE,STONESIZE)];
        _redStone.layer.cornerRadius = STONESIZE/2.;
        _redStone.image = [UIImage imageNamed:@"red_stone_small"];
        [self addSubview:_redStone];
        
        _yellowStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,STONESIZE,STONESIZE)];
        _yellowStone.layer.cornerRadius = STONESIZE/2.;
        _yellowStone.image = [UIImage imageNamed:@"yellow_stone_small"];
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

- (void)resetScore
{
    self.redScore = 8;
    self.yellowScore = 8;
}

#pragma mark - CURChangeScoreProtocol

- (BOOL)changeScoreForColor:(UIColor *)color byNumber:(NSInteger)number
{
    if (color==[UIColor redColor])
    {
        self.redScore += number;
        self.score.text = [NSString stringWithFormat:@"%ld:%ld", self.redScore, self.yellowScore];
    }
    else
    {
        self.yellowScore += number;
        self.score.text = [NSString stringWithFormat:@"%ld:%ld", self.redScore, self.yellowScore];
    }
    if (0 == self.redScore && 0 == self.yellowScore)
    {
        return YES;
    }
    return NO;
}

@end
