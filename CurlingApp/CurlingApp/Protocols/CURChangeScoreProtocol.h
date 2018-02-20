//
//  CURChangeScoreProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol CURChangeScoreProtocol <NSObject>
@optional

/**
 Вызывается для измения счета команды по цвету на определенную дельту.
 @param color Цвет команды, для которой нужно изменить счет.
 @param number Дельта, на которую нужно изменить счет.
 @returns YES, если энд закончился.
 */
- (BOOL)changeScoreForColor:(CURColors)color byNumber:(NSInteger)number;

/**
 Вызывается для установки номер энда.
 @param endNumber Номер энда.
 */
- (void)setEndNumber:(NSInteger)endNumber;

/**
 Вызывается для сбрасывания счета игры.
 */
- (void)resetScore;

@end

