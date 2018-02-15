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

- (NSArray *)loadAllGamesInfo;
- (NSArray *)loadAllStoneData;
- (NSArray *)loadAllEndScore;
- (AppData *)loadAppData;
- (GameInfo *)loadGamesInfoByHash:(NSString *)hashLink;
- (NSArray *)loadStonesDataByHash:(NSString *)hashLink;
- (NSArray *)loadStonesDataByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber;
- (NSArray *)loadEndScoreByHash:(NSString *)hashLink;
- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave;
- (void)saveStoneData:(CURStoneData *)stoneDataToSave;
- (void)saveNumberOfEnds:(int)number forHash:(NSString *)hashLink;
- (void)saveFirstScore:(int)firstScore andSecondScore:(int)secondScore forHash:(NSString *)hashLink;
- (void)saveFirstScore:(int)firstScore andSecondScore:(int)secondScore forEnd:(int)endNumber andHash:(NSString *)hashLink;
- (BOOL)saveAccessToken:(NSString *)accessToken;
- (void)deleteGameByHash:(NSString *)hashLink;
- (void)deleteEndByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber;
- (void)clearCoreData;

@end
