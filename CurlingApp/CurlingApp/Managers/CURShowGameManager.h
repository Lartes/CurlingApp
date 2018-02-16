//
//  CURShowGameManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CURChangeScoreProtocol.h"
#import "CURCoreDataManager.h"
#import "StoneData+CoreDataClass.h"
#import "GameInfo+CoreDataClass.h"
#import "Constants.h"

@interface CURShowGameManager : NSObject

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

/**
 Инициализурет менеджер просмотра игры.
 @param gameInfo Общая информация об игре.
 @param endNumber Номер энда с которого начать просмотр игры.
 @param stoneSize Размер камня, которому должно соответствовать его представление.
 */
- (instancetype)initWithGameInfo:(GameInfo *)gameInfo endNumber:(NSInteger)endNumber stoneSize:(NSInteger)stoneSize;

/**
 Запускает логику просмотра игры. Обязятелен к вызову в начале просмотра игры.
 @returns Массив камней типа UIView, манипуляция которыми будет осуществляться.
 */
- (NSArray<UIView *> *)startShowGame;

/**
 Переключение игровой ситуации на следующий шаг.
 @returns YES, если новый шаг - последний в энде.
 */
- (BOOL)showNextStep;

/**
 Переключение игровой ситуации на предыдущий шаг.
 @returns YES, если новый шаг - первый в энде.
 */
- (BOOL)showPreviousStep;
- (BOOL)changeEndByNumber:(NSInteger)number;

/**
 Проверка факта, что текущий энд - первый в игре.
 @returns YES, если текущий энд первый.
 */
- (BOOL)isFirstEnd;

/**
 Проверка факта, что текущий энд - последний в игре.
 @returns YES, если текущий энд последний.
 */
- (BOOL)isLastEnd;

@end
