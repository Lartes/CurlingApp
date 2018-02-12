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

@interface CURShowGameManager : NSObject

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

- (instancetype)initWithGameInfo:(GameInfo *)gameInfo andEndNumber:(NSInteger)endNumber;

- (NSArray *)startShowGame;
- (BOOL)showNextStep;
- (BOOL)showPreviousStep;
- (BOOL)changeEndOnNumber:(NSInteger)number;

- (BOOL)isFirstEnd;
- (BOOL)isLastEnd;

@end
