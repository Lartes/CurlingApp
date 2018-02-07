//
//  CURGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameManager.h"

@interface CURGameManager ()

@property (nonatomic, strong) NSMutableArray<UIView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) BOOL isEndFinishedBool;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, strong) UIColor *firstTeamColor;

@end

@implementation CURGameManager

- (instancetype)initWithColor:(UIColor *)firstStoneColor andHash:(NSString *)hashLink
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _isEndFinishedBool = NO;
        _stoneColor = firstStoneColor;
        _firstTeamColor = firstStoneColor;
        _endNumber = 0;
        _stepNumber = 1;
        _hashLink = hashLink;
    }
    return self;
}

- (UIView *)addStone
{
    if (self.stonesArray.count > 0)
    {
        [self saveToCoreData];
        self.stepNumber += 1;
    }
        
    UIView *stone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    stone.layer.cornerRadius = 15;
    stone.backgroundColor = self.stoneColor;
    self.isEndFinishedBool = [self.output changeScoreForColor:self.stoneColor byNumber:-1];
    [self changeColor];
    [self.stonesArray addObject:stone];
    return stone;
}

- (void)startEnd
{
    self.endNumber += 1;
    [self.stonesArray removeAllObjects];
    self.isEndFinishedBool = NO;
    self.stepNumber = 1;
}

- (void)finishEnd
{
    [self saveToCoreData];
}

- (void)finishGame
{
    [self.coreDataManager saveNumberOfEnds:self.endNumber forHash:self.hashLink];
}

- (BOOL)isEndFinished
{
    return self.isEndFinishedBool;
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

- (NSString *)getHashLink
{
    return self.hashLink;
}

- (NSInteger)getEndNumber
{
    return self.endNumber;
}

- (UIColor *)getFirstTeamColor
{
    return self.firstTeamColor;
}

- (void)setFirstStoneColor:(UIColor *)color
{
    self.stoneColor = color;
}

#pragma mark - CoreData

- (void)saveToCoreData
{
    CURStoneData *stoneData = nil;
    for (UIView *stone in self.stonesArray)
    {
        stoneData = [CURStoneData new];
        stoneData.endNumber = self.endNumber;
        stoneData.stepNumber = self.stepNumber;
        stoneData.isStoneColorRed = [stone backgroundColor] == [UIColor redColor];
        stoneData.stonePositionX = [stone center].x;
        stoneData.stonePositionY = [stone center].y;
        stoneData.hashLink = self.hashLink;
        
        [self.coreDataManager saveStoneData:stoneData];
    }
}

@end
