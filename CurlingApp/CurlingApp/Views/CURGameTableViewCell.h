//
//  CURGameTableViewCell.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Constants.h"

@interface CURGameTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *teamNameFirst;
@property (nonatomic, strong) UILabel *teamNameSecond;
@property (nonatomic, strong) UILabel *teamsScore;
@property (nonatomic, strong) UIView *colorBarFirst;
@property (nonatomic, strong) UIView *colorBarSecond;
@property (nonatomic, strong) UIView *colorBarScoreFirst;
@property (nonatomic, strong) UIView *colorBarScoreSecond;

/**
 Изменяет цвет первой команды на желтый.
 */
- (void)makeFirstTeamColorYellow;

@end
