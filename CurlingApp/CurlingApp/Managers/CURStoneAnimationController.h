//
//  CURStoneAnimationController.h
//  CurlingApp
//
//  Created by Artem Lomov on 17/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CURStoneAnimationProtocol.h"

@interface CURStoneAnimationController : NSObject

@property (nonatomic, strong) id<CURStoneAnimationProtocol> output;

/**
 Инициализирует контроллер анимации камней с view на котором они находятся и объектами камней.
 @param view View, на котором находятся камни.
 @param firstStone Первый камень, который будет анимироваться.
 @param secondStone Второй камень, который будет анимироваться.
 */
- (instancetype)initWithView:(UIView *)view firstStone:(UIView *)firstStone secondStone:(UIView *)secondStone;

/**
 Инициализирует контроллер анимации камней с view в котором они находятся и объектами камней.
 @param endPoint Точка, в которой должна закончиться анимация.
 */
- (void)runStoneAnimationToPoint:(CGPoint)endPoint;

@end
