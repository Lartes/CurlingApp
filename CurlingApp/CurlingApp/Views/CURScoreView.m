//
//  CURScoreView.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScoreView.h"

@interface CURScoreView ()

@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UILabel *endNumberLabel;
@property (nonatomic, strong) UIImageView *redStone;
@property (nonatomic, strong) UIImageView *yellowStone;
@property (nonatomic, assign) NSInteger redScore;
@property (nonatomic, assign) NSInteger yellowScore;
@property (nonatomic, assign) CGFloat centerX;

@end

@implementation CURScoreView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame centerX:(CGFloat)centerX
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _redScore = CURScoreViewMaximumScore;
        _yellowScore = CURScoreViewMaximumScore;
        _centerX = centerX;
        
        _score = [[UILabel alloc]initWithFrame:CGRectZero];
        _score.text = [NSString stringWithFormat:@"%d:%d", CURScoreViewMaximumScore, CURScoreViewMaximumScore];
        _score.textAlignment = NSTextAlignmentCenter;
        _score.textColor = [UIColor blackColor];
        _score.font = [UIFont systemFontOfSize:CURSmallFontSize];
        [self addSubview:_score];
        
        _endNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _endNumberLabel.text = @"1 энд";
        _endNumberLabel.textAlignment = NSTextAlignmentCenter;
        _endNumberLabel.textColor = [UIColor blackColor];
        _endNumberLabel.font = [UIFont systemFontOfSize:CURSmallFontSize];
        [self addSubview:_endNumberLabel];
        
        _redStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,CURScoreViewStoneImageSize,CURScoreViewStoneImageSize)];
        _redStone.layer.cornerRadius = CURScoreViewStoneImageSize/2.;
        _redStone.image = [UIImage imageNamed:@"red_stone_small"];
        [self addSubview:_redStone];
        
        _yellowStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,CURScoreViewStoneImageSize,CURScoreViewStoneImageSize)];
        _yellowStone.layer.cornerRadius = CURScoreViewStoneImageSize/2.;
        _yellowStone.image = [UIImage imageNamed:@"yellow_stone_small"];
        [self addSubview:_yellowStone];
    }
    return self;
}

- (void)layoutSubviews
{
    self.score.frame = CGRectMake(0, 0, CURScoreViewLabelSize, CGRectGetHeight(self.frame));
    self.score.center = CGPointMake(self.centerX, self.center.y);
    self.yellowStone.center = CGPointMake(self.centerX+CURScoreViewLabelSize/2.+CURScoreViewStoneImageSize/2., self.center.y);
    self.redStone.center = CGPointMake(self.centerX-CURScoreViewLabelSize/2.-CURScoreViewStoneImageSize/2., self.center.y);
    self.endNumberLabel.frame = CGRectMake(0, 0, CURScoreViewLabelSize, CGRectGetHeight(self.frame));
}


#pragma mark - CURChangeScoreProtocol

- (BOOL)changeScoreForColor:(CURColors)color byNumber:(NSInteger)number
{
    if (color==CURRedColor)
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

- (void)setEndNumber:(NSInteger)endNumber
{
    _endNumberLabel.text = [NSString stringWithFormat:@"%ld энд", endNumber];
}

- (void)resetScore
{
    self.redScore = CURScoreViewMaximumScore;
    self.yellowScore = CURScoreViewMaximumScore;
}

@end
