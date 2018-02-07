//
//  CURShowGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURShowGameManager.h"
#import "StoneData+CoreDataClass.h"

@interface CURShowGameManager ()

@property (nonatomic, strong) NSArray<UIView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) NSInteger numberOfEnds;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, strong) NSArray<StoneData *> *stonesData;
@property (nonatomic, assign) NSInteger indexInStonesData;

@end

@implementation CURShowGameManager

- (instancetype)initWithGameInfo:(GameInfo *)gameInfo
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _stonesData = nil;
        _endNumber = 1;
        _stoneColor = [UIColor redColor];
        _stepNumber = 0;
        _hashLink = gameInfo.hashLink;
        _numberOfEnds = gameInfo.numberOfEnds;
        _indexInStonesData = 0;
    }
    return self;
}

- (NSArray *)startShowGame
{
    self.stonesData = [self.coreDataManager loadStonesDataByHash:self.hashLink andEndNumber:self.endNumber];

    NSMutableArray *stones = [NSMutableArray new];
    UIView *stone = nil;
    for (int i = 0; i<16; i++)
    {
        stone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        stone.layer.cornerRadius = 15;
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
        self.stonesArray[indexInStonesArray].backgroundColor = stone.isStoneColorRed ? [UIColor redColor] : [UIColor yellowColor];
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
        self.stonesArray[indexInStonesArray].backgroundColor = stone.isStoneColorRed ? [UIColor redColor] : [UIColor yellowColor];
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
