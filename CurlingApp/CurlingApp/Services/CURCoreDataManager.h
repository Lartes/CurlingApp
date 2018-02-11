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
#import "CURGameInfo.h"
#import "CURStoneData.h"

@interface CURCoreDataManager : NSObject

- (NSArray *)loadAllGamesInfo;
- (GameInfo *)loadGamesInfoByHash:(NSString *)hashLink;
- (NSArray *)loadStonesDataByHash:(NSString *)hashLink;
- (NSArray *)loadStonesDataByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber;
- (NSArray *)loadEndScoreByHash:(NSString *)hashLink;
- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave;
- (void)saveStoneData:(CURStoneData *)stoneDataToSave;
- (void)saveNumberOfEnds:(NSInteger)number forHash:(NSString *)hashLink;
- (void)saveFirstScore:(NSInteger)firstScore andSecondScore:(NSInteger)secondScore forHash:(NSString *)hashLink;
- (void)saveFirstScore:(NSInteger)firstScore andSecondScore:(NSInteger)secondScore forEnd:(NSInteger)endNumber andHash:(NSString *)hashLink;
- (void)deleteGameByHash:(NSString *)hashLink;
- (void)deleteEndByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber;
- (void)clearCoreData;

@end
