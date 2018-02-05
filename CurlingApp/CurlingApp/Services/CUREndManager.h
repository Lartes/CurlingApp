//
//  CUREndManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CURChangeScoreProtocol.h"

@interface CUREndManager : NSObject

- (instancetype)initWithColor:(UIColor *)color;
- (UIView *)addStone;
- (BOOL)isEndFinished;

@property (nonatomic, weak) id<CURChangeScoreProtocol> output;

@end
