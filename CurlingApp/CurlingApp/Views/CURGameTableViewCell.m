//
//  CURGameTableViewCell.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameTableViewCell.h"

static const float LABELHEIGHT = 40.;
static const float INDENT = 10.;

@implementation CURGameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _teamNameFirst = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 0., 0.)];
        [self.contentView addSubview:_teamNameFirst];
        
        _teamNameSecond = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 0., 0.)];
        [self.contentView addSubview:_teamNameSecond];
    }
    return self;
}

- (void)layoutSubviews
{
    self.teamNameFirst.frame = CGRectMake(INDENT, INDENT, CGRectGetWidth(self.contentView.frame)-INDENT*2, LABELHEIGHT);
    self.teamNameSecond.frame = CGRectMake(INDENT, LABELHEIGHT + INDENT*2, CGRectGetWidth(self.contentView.frame)-INDENT*2, LABELHEIGHT);
    self.teamNameFirst.backgroundColor = [UIColor redColor];
    self.teamNameSecond.backgroundColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
