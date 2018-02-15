//
//  CURScoreTableViewCell.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScoreTableViewCell.h"

@implementation CURScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _score = [UILabel new];
        _endNumber = [UILabel new];
        
        _score.textAlignment = NSTextAlignmentCenter;
        _endNumber.textAlignment = NSTextAlignmentCenter;
        
        _score.textColor = [UIColor blackColor];
        _endNumber.textColor = [UIColor blackColor];
        
        _score.font = [UIFont systemFontOfSize:MEDIUMFONT];
        
        [self.contentView addSubview:_score];
        [self.contentView addSubview:_endNumber];
    }
    return self;
}

- (void)updateConstraints
{
    [self.score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.endNumber);
        make.bottom.mas_equalTo(self.endNumber);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.endNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(INDENT/2.);
        make.bottom.mas_equalTo(self.contentView).with.offset(-INDENT/2.);
        make.left.mas_equalTo(self.contentView).with.offset(INDENT);
    }];
    
    [super updateConstraints];
}

@end
