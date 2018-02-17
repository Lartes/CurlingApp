//
//  CURShowGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURShowGameManager.h"

@interface CURShowGameManager ()

@property (nonatomic, copy) NSArray<UIImageView *> *stonesArray;
@property (nonatomic, assign) CURColors stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) NSInteger numberOfEnds;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, copy) NSArray<StoneData *> *stonesData;
@property (nonatomic, assign) NSInteger indexInStonesData;
@property (nonatomic, strong) UIImage *redStone;
@property (nonatomic, strong) UIImage *yellowStone;
@property (nonatomic, assign) NSInteger stoneSize;

@end

@implementation CURShowGameManager


#pragma mark - Lifecycle

- (instancetype)initWithGameInfo:(GameInfo *)gameInfo endNumber:(NSInteger)endNumber stoneSize:(NSInteger)stoneSize;
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _stonesData = nil;
        _stoneSize = stoneSize;
        _endNumber = endNumber;
        _stepNumber = 0;
        _hashLink = gameInfo.hashLink;
        _numberOfEnds = gameInfo.numberOfEnds;
        _indexInStonesData = 0;
        _redStone = [UIImage imageNamed:@"stone_red"];
        _yellowStone = [UIImage imageNamed:@"stone_yellow"];
        
    }
    return self;
}


#pragma mark - Game Actions

- (NSArray *)startShowGame
{
    [self.output setEndNumber:self.endNumber];
    self.stonesData = [self.coreDataManager loadStonesDataByHash:self.hashLink endNumber:self.endNumber];
    self.stoneColor = self.stonesData[0].isStoneColorRed ? CURRedColor : CURYellowColor;
    
    NSMutableArray *stones = [NSMutableArray new];
    UIImageView *stone = nil;
    for (int i = 0; i<CURShowGameManagerNumberOfStonesPerEnd; i++)
    {
        stone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.stoneSize, self.stoneSize)];
        stone.userInteractionEnabled = YES;
        stone.layer.cornerRadius = self.stoneSize/2.;
        stone.hidden = YES;
        [stones addObject:stone];
    }
    self.stonesArray = [stones copy];
    
    [self showNextStep];
    return self.stonesArray;
}

- (BOOL)changeEndByNumber:(NSInteger)number;
{
    self.endNumber += number;
    [self.output setEndNumber:self.endNumber];
    self.stonesData = [self.coreDataManager loadStonesDataByHash:self.hashLink endNumber:self.endNumber];
    self.stoneColor = self.stonesData[0].isStoneColorRed ? CURRedColor : CURYellowColor;
    for (int i = 0; i<CURShowGameManagerNumberOfStonesPerEnd; i++)
    {
        self.stonesArray[i].hidden = YES;
    }
    self.stepNumber = 0;
    self.indexInStonesData = 0;
    
    [self showNextStep];
    return (self.endNumber == 1 || self.endNumber == self.numberOfEnds);
}

- (BOOL)showNextStep
{
    self.stepNumber += 1;
    while (self.stonesData.count > self.indexInStonesData && self.stonesData[self.indexInStonesData].stepNumber != self.stepNumber)
    {
        self.indexInStonesData += 1;
    };
    
    NSInteger indexInStonesArray = 0;
    StoneData * stone = nil;
    while (self.stonesData.count > self.indexInStonesData && self.stonesData[self.indexInStonesData].stepNumber == self.stepNumber)
    {
        stone = self.stonesData[self.indexInStonesData];
        self.stonesArray[indexInStonesArray].center = CGPointMake(stone.stonePositionX, stone.stonePositionY);
        self.stonesArray[indexInStonesArray].image = stone.isStoneColorRed ? self.redStone : self.yellowStone;
        self.stonesArray[indexInStonesArray].hidden = NO;
        
        indexInStonesArray += 1;
        self.indexInStonesData += 1;
    }
    self.indexInStonesData -= 1;
    
    [self.output changeScoreForColor:self.stoneColor byNumber:-1];
    self.stoneColor = self.stoneColor == CURRedColor ? CURYellowColor : CURRedColor;
    
    return (self.stepNumber == CURShowGameManagerNumberOfStonesPerEnd);
}

- (BOOL)showPreviousStep
{
    self.stepNumber -= 1;
    while (self.indexInStonesData >= 0 && self.stonesData[self.indexInStonesData].stepNumber != self.stepNumber)
    {
        self.indexInStonesData -= 1;
    };
    
    NSInteger indexInStonesArray = 0;
    StoneData * stone = nil;
    while (self.indexInStonesData >= 0 && self.stonesData[self.indexInStonesData].stepNumber == self.stepNumber)
    {
        stone = self.stonesData[self.indexInStonesData];
        self.stonesArray[indexInStonesArray].center = CGPointMake(stone.stonePositionX, stone.stonePositionY);
        self.stonesArray[indexInStonesArray].image = stone.isStoneColorRed ? self.redStone : self.yellowStone;
        self.stonesArray[indexInStonesArray].hidden = NO;
        
        indexInStonesArray += 1;
        self.indexInStonesData -= 1;
    }
    self.indexInStonesData += 1;
    for (; indexInStonesArray<CURShowGameManagerNumberOfStonesPerEnd; indexInStonesArray++)
    {
        self.stonesArray[indexInStonesArray].hidden = YES;
    }
    
    self.stoneColor = self.stoneColor == CURRedColor ? CURYellowColor : CURRedColor;
    [self.output changeScoreForColor:self.stoneColor byNumber:1];
    
    return (self.stepNumber == 1);
}

- (BOOL)isFirstEnd
{
    return self.endNumber == 1;
}

- (BOOL)isLastEnd
{
    return self.endNumber == self.numberOfEnds;
}

@end
