//
//  CURCoreDataManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameInfo+CoreDataClass.h"
#import "StoneData+CoreDataClass.h"
#import "EndScore+CoreDataClass.h"
#import "AppData+CoreDataClass.h"
#import "CURGameInfo.h"
#import "CURStoneData.h"

@interface CURCoreDataManager : NSObject

/**
 Предоставляет информацию по всем играм.
 @returns Массив GameInfo с информацией об играх.
 */
- (NSArray<GameInfo *> *)loadAllGamesInfo;

/**
 Предоставляет информацию по всем камням.
 @returns Массив с элементами типа StoneData с информацией о камнях.
 */
- (NSArray<StoneData *> *)loadAllStoneData;

/**
 Предоставляет информацию о всех счетах.
 @returns Массив с элементами типа EndScore с информацией о счетах.
 */
- (NSArray<EndScore *> *)loadAllEndScore;

/**
 Предоставляет информацию о системных настройках приложения.
 @returns Системные настройки приложения.
 */
- (AppData *)loadAppData;

/**
 Предоставляет информация об игре, соответствеющей хеш-связи.
 @param hashLink Хеш-связь игры.
 @returns Информация по игре.
 */
- (GameInfo *)loadGamesInfoByHash:(NSString *)hashLink;

/**
 Предоставляет информация о камнях, соответствеющих хеш-связи.
 @param hashLink Хеш-связь игры.
 @returns Массив с информацией о камнях.
 */
- (NSArray<StoneData *> *)loadStonesDataByHash:(NSString *)hashLink;

/**
 Предоставляет информация о камнях, соответствеющих хеш-связи, для конкретного энда.
 @param hashLink Хеш-связь игры.
 @param endNumber Номер энда в игре.
 @returns Массив с информацией о камнях.
 */
- (NSArray<StoneData *> *)loadStonesDataByHash:(NSString *)hashLink endNumber:(NSInteger)endNumber;

/**
 Предоставляет информация о счетах, соответствеющих хеш-связи.
 @param hashLink Хеш-связь игры.
 @returns Массив с информацией о счетах.
 */
- (NSArray<EndScore *> *)loadEndScoreByHash:(NSString *)hashLink;

/**
 Сохраняет данные по игре.
 @param gameInfoToSave Данные по игре.
 */
- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave;

/**
 Сохраняет данные о камне.
 @param stoneDataToSave Данные о камне.
 */
- (void)saveStoneData:(CURStoneData *)stoneDataToSave;

/**
 Сохраняет данные о количестве эндов в информацию об игре по хеш-связи.
 @param number Количество эндов.
 @param hashLink Хеш-связь игры.
 */
- (void)saveNumberOfEnds:(int)number forHash:(NSString *)hashLink;

/**
 Сохраняет счет игры в информацию об игре по хеш-связи.
 @param firstScore Счет первой команды.
 @param secondScore Счет второй команды.
 @param hashLink Хеш-связь игры.
 */
- (void)saveFirstScore:(int)firstScore secondScore:(int)secondScore forHash:(NSString *)hashLink;

/**
 Сохраняет счет энда по хеш-связи.
 @param firstScore Счет первой команды.
 @param secondScore Счет второй команды.
 @param endNumber Номер энда.
 @param hashLink Хеш-связь игры.
 */
- (void)saveFirstScore:(int)firstScore secondScore:(int)secondScore forEnd:(int)endNumber hash:(NSString *)hashLink;

/**
 Сохраняет токен авторизации.
 @param accessToken Токен авторизации.
 @returns YES, если сохранение завершилось успешно.
 */
- (BOOL)saveAccessToken:(NSString *)accessToken;

/**
 Удаляет всю информация по игре по хеш-связи.
 @param hashLink Хеш-связь игры.
 */
- (void)deleteGameByHash:(NSString *)hashLink;

/**
 Удаляет всю информация об энде по хеш-связи.
 @param endNumber Номер энда.
 @param hashLink Хеш-связь игры.
 */
- (void)deleteEndByHash:(NSString *)hashLink endNumber:(NSInteger)endNumber;

/**
 Удаляет всю информация по всем играм.
 */
- (void)clearCoreData;

@end
