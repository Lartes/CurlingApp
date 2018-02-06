//
//  CURCoreDataManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameInfo+CoreDataClass.h"
#import "StoneData+CoreDataClass.h"
#import "CURGameInfo.h"
#import "CURStoneData.h"

@interface CURCoreDataManager : NSObject

- (NSArray *)loadAllGamesInfo;
- (NSArray *)loadGamesInfoByHash:(NSString *)hashLink;
- (NSArray *)loadStonesDataByHash:(NSString *)hashLink;
- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave;
- (void)saveStoneData:(CURStoneData *)stoneDataToSave;
- (void)deleteGame:(GameInfo *)gameInfo;

@end
