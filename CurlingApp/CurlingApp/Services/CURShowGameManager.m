//
//  CURShowGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURShowGameManager.h"

@interface CURShowGameManager ()

@property (nonatomic, strong) NSArray<UIImageView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) NSInteger numberOfEnds;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, strong) NSArray<StoneData *> *stonesData;
@property (nonatomic, assign) NSInteger indexInStonesData;
@property (nonatomic, strong) UIImage *redStone;
@property (nonatomic, strong) UIImage *yellowStone;

@end

@implementation CURShowGameManager

- (instancetype)initWithGameInfo:(GameInfo *)gameInfo andEndNumber:(NSInteger)endNumber;
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _stonesData = nil;
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

- (NSArray *)startShowGame
{
    self.stonesData = [self.coreDataManager loadStonesDataByHash:self.hashLink andEndNumber:self.endNumber];
    self.stoneColor = self.stonesData[0].isStoneColorRed ? [UIColor redColor] : [UIColor yellowColor];
    
    NSMutableArray *stones = [NSMutableArray new];
    UIImageView *stone = nil;
    for (int i = 0; i<16; i++)
    {
        stone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        stone.userInteractionEnabled = YES;
        stone.layer.cornerRadius = 18;
        stone.hidden = YES;
        [stones addObject:stone];
    }
    self.stonesArray = [stones copy];
    
    [self showNextStep];
    return self.stonesArray;
}

- (BOOL)changeEndOnNumber:(NSInteger)number;
{
    self.endNumber += number;
    self.stonesData = [self.coreDataManager loadStonesDataByHash:self.hashLink andEndNumber:self.endNumber];
    self.stoneColor = self.stonesData[0].isStoneColorRed ? [UIColor redColor] : [UIColor yellowColor];
    for (int i = 0; i<16; i++)
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
    [self changeColor];
    
    if (self.stepNumber == 16)
    {
        return YES;
    }
    return NO;
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
    for (; indexInStonesArray<16; indexInStonesArray++)
    {
        self.stonesArray[indexInStonesArray].hidden = YES;
    }
    
    [self changeColor];
    [self.output changeScoreForColor:self.stoneColor byNumber:1];
    
    if (self.stepNumber == 1)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isFirstEnd
{
    return self.endNumber == 1;
}

- (BOOL)isLastEnd
{
    return self.endNumber == self.numberOfEnds;
}

- (void)changeColor
{
    if (self.stoneColor==[UIColor redColor])
    {
        self.stoneColor = [UIColor yellowColor];
    }
    else
    {
        self.stoneColor = [UIColor redColor];
    }
}

@end
