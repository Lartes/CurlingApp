//
//  CURCoreDataTypesForTests.h
//  CurlingAppTests
//
//  Created by Artem Lomov on 19/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameInfoTest : NSObject

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *teamNameFirst;
@property (nullable, nonatomic, copy) NSString *teamNameSecond;
@property (nullable, nonatomic, copy) NSString *hashLink;
@property (nonatomic) int32_t numberOfEnds;
@property (nonatomic) int32_t firstTeamScore;
@property (nonatomic) int32_t secondTeamScore;
@property (nonatomic) BOOL isFirstTeamColorRed;

@end



@interface StoneDataTest : NSObject

@property (nonatomic) int32_t endNumber;
@property (nonatomic) BOOL isStoneColorRed;
@property (nonatomic) int32_t stepNumber;
@property (nonatomic) float stonePositionX;
@property (nonatomic) float stonePositionY;
@property (nullable, nonatomic, copy) NSString *hashLink;

- (instancetype)initWithStepNumber:(int32_t)stepNumber position:(CGPoint)position isRedColor:(BOOL)isStoneColorRed;

@end



@interface EndScoreTest : NSObject

@property (nonatomic) int32_t endNumber;
@property (nullable, nonatomic, copy) NSString *hashLink;
@property (nonatomic) int32_t firstTeamScore;
@property (nonatomic) int32_t secondTeamScore;

@end


