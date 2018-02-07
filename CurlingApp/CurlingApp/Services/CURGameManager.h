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

@interface CURGameManager : NSObject

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

- (instancetype)initWithColor:(UIColor *)firstStoneColor andHash:(NSString *)hashLink;

- (void)startEnd;
- (UIView *)addStone;
- (BOOL)isEndFinished;
- (void)finishEnd;
- (void)finishGame;

- (NSString *)getHashLink;

@end
