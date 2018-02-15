//
//  CURGameTableViewCell.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameTableViewCell.h"

@implementation CURGameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _teamNameFirst = [UILabel new];
        _teamNameSecond = [UILabel new];
        _teamsScore = [UILabel new];
        _colorBarFirst = [UIView new];
        _colorBarSecond = [UIView new];
        _colorBarScoreFirst = [UIView new];
        _colorBarScoreSecond = [UIView new];
        
        _teamNameFirst.adjustsFontSizeToFitWidth = YES;
        _teamNameSecond.adjustsFontSizeToFitWidth = YES;
        _teamsScore.adjustsFontSizeToFitWidth = YES;
        
        _teamNameFirst.numberOfLines = 1;
        _teamNameSecond.numberOfLines = 1;
        _teamsScore.numberOfLines = 1;
        
        _teamNameFirst.textColor = [UIColor blackColor];
        _teamNameSecond.textColor = [UIColor blackColor];
        _teamsScore.textColor = [UIColor blackColor];

        _teamsScore.textAlignment = NSTextAlignmentCenter;
        _teamsScore.font = [UIFont systemFontOfSize:BIGFONT];
        _teamNameFirst.font = [UIFont systemFontOfSize:SMALLFONT];
        _teamNameSecond.font = [UIFont systemFontOfSize:SMALLFONT];
        
        _colorBarFirst.backgroundColor = [UIColor redColor];
        _colorBarScoreFirst.backgroundColor = [UIColor redColor];
        _colorBarSecond.backgroundColor = [UIColor yellowColor];
        _colorBarScoreSecond.backgroundColor = [UIColor yellowColor];

        [self.contentView addSubview:_teamNameFirst];
        [self.contentView addSubview:_teamNameSecond];
        [self.contentView addSubview:_teamsScore];
        [self.contentView addSubview:_colorBarFirst];
        [self.contentView addSubview:_colorBarSecond];
        [self.contentView addSubview:_colorBarScoreFirst];
        [self.contentView addSubview:_colorBarScoreSecond];
    }
    return self;
}

- (void)updateConstraints
{
    [self.teamNameFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colorBarFirst.mas_right).with.offset(INDENT);
        make.top.mas_equalTo(self.contentView).with.offset(INDENT);
    }];
    [self.teamNameSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.teamNameFirst);
        make.left.mas_equalTo(self.teamNameFirst);
        make.top.mas_equalTo(self.teamNameFirst.mas_bottom);
        make.bottom.mas_equalTo(self.contentView).with.offset(-INDENT);
    }];
    [self.colorBarFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).with.offset(INDENT);
        make.top.mas_equalTo(self.contentView).with.offset(INDENT);
        make.width.mas_equalTo(INDENT);
    }];
    [self.colorBarSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.colorBarFirst);
        make.left.mas_equalTo(self.colorBarFirst);
        make.top.mas_equalTo(self.colorBarFirst.mas_bottom);
        make.bottom.mas_equalTo(self.contentView).with.offset(-INDENT);
    }];
    
    [self.colorBarScoreFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.teamNameFirst.mas_right);
        make.top.mas_equalTo(self.teamsScore);
        make.bottom.mas_equalTo(self.teamsScore);
        make.width.mas_equalTo(INDENT);
    }];
    [self.teamsScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colorBarScoreFirst.mas_right).with.offset(INDENT);
        make.top.mas_equalTo(self.contentView).with.offset(INDENT);
        make.bottom.mas_equalTo(self.contentView).with.offset(-INDENT);
    }];
    [self.colorBarScoreSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.colorBarScoreFirst);
        make.left.mas_equalTo(self.teamsScore.mas_right).with.offset(INDENT);
        make.right.mas_equalTo(self.contentView).with.offset(-INDENT);
        make.top.mas_equalTo(self.teamsScore);
        make.bottom.mas_equalTo(self.teamsScore);
    }];
    
    [super updateConstraints];
}

- (void)makeFirstTeamColorYellow
{
    _colorBarFirst.backgroundColor = [UIColor yellowColor];
    _colorBarScoreFirst.backgroundColor = [UIColor yellowColor];
    _colorBarSecond.backgroundColor = [UIColor redColor];
    _colorBarScoreSecond.backgroundColor = [UIColor redColor];
}

@end
