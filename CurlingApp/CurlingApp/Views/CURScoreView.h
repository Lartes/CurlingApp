//
//  CURScoreView.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURChangeScoreProtocol.h"
#import "Constants.h"

@interface CURScoreView : UIView <CURChangeScoreProtocol>

/**
 Инициализирует объект по фрейму и центру на родительском view.
 @param frame Фрейм.
 @param centerX Центр на родительском view.
 */
- (instancetype)initWithFrame:(CGRect)frame centerX:(CGFloat)centerX;

/**
 Сбрасывает счет команд.
 */
- (void)resetScore;

@end
