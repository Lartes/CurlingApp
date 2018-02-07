//
//  CURScoreTableViewCell.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURScoreTableViewCell.h"

static const float LABELHEIGHT = 40.;
static const float INDENT = 10.;

@implementation CURScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _score = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 0., 0.)];
        [self.contentView addSubview:_score];
    }
    return self;
}

- (void)layoutSubviews
{
    self.score.frame = CGRectMake(INDENT, INDENT, CGRectGetWidth(self.contentView.frame)-INDENT*2, LABELHEIGHT);
    self.score.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
