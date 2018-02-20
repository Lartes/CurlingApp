//
//  CURGameManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CURChangeScoreProtocol.h"
#import "CURCoreDataManager.h"
#import "StoneData+CoreDataClass.h"
#import "Constants.h"

@interface CURGameManager : NSObject

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

/**
 Инициализирует менеджер игры.
 @param firstStoneColor Цвет первого камня в игре.
 @param hashLink Хеш-связь игры.
 @param stoneSize Размер камня, которому должно соответствовать его представление.
 */
- (instancetype)initWithColor:(CURColors)firstStoneColor hash:(NSString *)hashLink stoneSize:(NSInteger)stoneSize;

/**
 Запускает игровую логику энда. Обязателен к вызову в начале энда.
 */
- (void)startEnd;

/**
 Создает новый игровой камень.
 @returns Объект типа UIImageView, являющийся сущностью игрового камня.
 */
- (UIImageView *)addStone;

/**
 Проверяет, закончился ли энд.
 @returns Логическое значение соответствующее игровому состоянию энда.
 */
- (BOOL)isEndFinished;

/**
 Завершает логику игрового энда и сохраняет его результаты. Обязателен к вызову в конце энда.
 */
- (void)finishEnd;

/**
 Завершает логику игры. Обязателен к вызову в конце игры.
 */
- (void)finishGame;

/**
 Устанавливает цвет первого камня в энде.
 @param color Цвет первого камня в энде
 */
- (void)setFirstStoneColor:(CURColors)color;

/**
 Предоставляет хеш-связь текущей игры.
 @returns Хеш-связь текущей игры.
 */
- (NSString *)getHashLink;

/**
 Предоставляет номер текущего энда.
 @returns Номер текущего энда.
 */
- (NSInteger)getEndNumber;

/**
 Предоставляет цвет команды, начинающей игру.
 @returns Цвет команды, начинающей игру.
 */
- (CURColors)getFirstTeamColor;

@end
