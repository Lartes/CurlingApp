//
//  CURCoreDataTypesForTests.m
//  CurlingAppTests
//
//  Created by Artem Lomov on 19/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCoreDataTypesForTests.h"

@implementation GameInfoTest

@end

@implementation StoneDataTest

- (instancetype)initWithStepNumber:(int32_t)stepNumber position:(CGPoint)position isRedColor:(BOOL)isStoneColorRed
{
    self = [super init];
    if(self)
    {
        _stepNumber = stepNumber;
        _stonePositionX = position.x;
        _stonePositionY = position.y;
        _isStoneColorRed = isStoneColorRed;
    }
    return self;
}

@end

@implementation EndScoreTest

@end
