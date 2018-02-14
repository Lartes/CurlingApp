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

- (instancetype)initWithFrame:(CGRect)frame andCenterX:(CGFloat)centerX
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _redScore = MAXSCORE;
        _yellowScore = MAXSCORE;
        _centerX = centerX;
        
        _score = [[UILabel alloc]initWithFrame:CGRectZero];
        _score.text = [NSString stringWithFormat:@"%d:%d", MAXSCORE, MAXSCORE];
        _score.textAlignment = NSTextAlignmentCenter;
        _score.textColor = [UIColor blackColor];
        _score.font = [UIFont systemFontOfSize:SMALLFONT];
        [self addSubview:_score];
        
        _endNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _endNumberLabel.text = @"1 энд";
        _endNumberLabel.textAlignment = NSTextAlignmentCenter;
        _endNumberLabel.textColor = [UIColor blackColor];
        _endNumberLabel.font = [UIFont systemFontOfSize:SMALLFONT];
        [self addSubview:_endNumberLabel];
        
        _redStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,STONESIZEFORLABEL,STONESIZEFORLABEL)];
        _redStone.layer.cornerRadius = STONESIZEFORLABEL/2.;
        _redStone.image = [UIImage imageNamed:@"red_stone_small"];
        [self addSubview:_redStone];
        
        _yellowStone = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,STONESIZEFORLABEL,STONESIZEFORLABEL)];
        _yellowStone.layer.cornerRadius = STONESIZEFORLABEL/2.;
        _yellowStone.image = [UIImage imageNamed:@"yellow_stone_small"];
        [self addSubview:_yellowStone];
    }
    return self;
}

- (void)layoutSubviews
{
    self.score.frame = CGRectMake(0, 0, LABELSIZE, CGRectGetHeight(self.frame));
    self.score.center = CGPointMake(self.centerX, self.center.y);
    self.yellowStone.center = CGPointMake(self.centerX+LABELSIZE/2.+STONESIZEFORLABEL/2., self.center.y);
    self.redStone.center = CGPointMake(self.centerX-LABELSIZE/2.-STONESIZEFORLABEL/2., self.center.y);
    self.endNumberLabel.frame = CGRectMake(0, 0, LABELSIZE, CGRectGetHeight(self.frame));
}

- (void)resetScore
{
    self.redScore = MAXSCORE;
    self.yellowScore = MAXSCORE;
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

- (void)setEndNumber:(NSInteger)endNumber
{
    _endNumberLabel.text = [NSString stringWithFormat:@"%ld энд", endNumber];
}

@end
