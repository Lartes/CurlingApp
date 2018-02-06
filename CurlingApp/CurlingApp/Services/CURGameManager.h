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

@interface CURGameManager : NSObject

- (instancetype)initWithColor:(UIColor *)firstStoneColor andHash:(NSString *)hashLink;
- (UIView *)addStone;
- (BOOL)isEndFinished;
- (void)finishEnd;
- (void)startEnd;
- (NSString *)getHashLink;

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end
