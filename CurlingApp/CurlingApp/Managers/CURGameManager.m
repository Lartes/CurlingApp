//
//  CURGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameManager.h"

@interface CURGameManager ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *stonesArray;
@property (nonatomic, assign) CURColors stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) BOOL isEndFinishedBool;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, assign) CURColors firstTeamColor;
@property (nonatomic, strong) UIImage *redStone;
@property (nonatomic, strong) UIImage *yellowStone;
@property (nonatomic, assign) NSInteger stoneSize;

@end

@implementation CURGameManager


#pragma mark - Lifecycle

- (instancetype)initWithColor:(CURColors)firstStoneColor hash:(NSString *)hashLink stoneSize:(NSInteger)stoneSize
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _isEndFinishedBool = NO;
        _stoneSize = stoneSize;
        _stoneColor = firstStoneColor;
        _firstTeamColor = firstStoneColor;
        _endNumber = 0;
        _stepNumber = 1;
        _hashLink = hashLink;
        _redStone = [UIImage imageNamed:@"stone_red"];
        _yellowStone = [UIImage imageNamed:@"stone_yellow"];
    }
    return self;
}


#pragma mark - Game Actions

- (UIView *)addStone
{
    if (self.stonesArray.count > 0)
    {
        [self saveToCoreData];
        self.stepNumber += 1;
    }
        
    UIImageView *stone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.stoneSize, self.stoneSize)];
    stone.userInteractionEnabled = YES;
    stone.layer.cornerRadius = self.stoneSize/2.;
    stone.image = self.stoneColor == CURRedColor ? self.redStone : self.yellowStone;
    self.isEndFinishedBool = [self.output changeScoreForColor:self.stoneColor byNumber:-1];
    self.stoneColor = self.stoneColor == CURRedColor ? CURYellowColor : CURRedColor;
    [self.stonesArray addObject:stone];
    return stone;
}

- (void)startEnd
{
    self.endNumber += 1;
    [self.output setEndNumber:self.endNumber];
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
    int firstTeamScore = 0;
    int secondTeamScore = 0;
    NSArray<EndScore *> *endScores = [self.coreDataManager loadEndScoreByHash:self.hashLink];
    for (EndScore *endScore in endScores)
    {
        firstTeamScore += endScore.firstTeamScore;
        secondTeamScore += endScore.secondTeamScore;
    }
    [self.coreDataManager saveFirstScore:firstTeamScore secondScore:secondTeamScore forHash:self.hashLink];
    
    [self.coreDataManager saveNumberOfEnds:self.endNumber forHash:self.hashLink];
}

- (BOOL)isEndFinished
{
    return self.isEndFinishedBool;
}


#pragma mark - Custom Accessors

- (NSString *)getHashLink
{
    return self.hashLink;
}

- (NSInteger)getEndNumber
{
    return self.endNumber;
}

- (CURColors)getFirstTeamColor
{
    return self.firstTeamColor;
}

- (void)setFirstStoneColor:(CURColors)color
{
    self.stoneColor = color;
}


#pragma mark - Private

- (void)saveToCoreData
{
    CURStoneData *stoneData = nil;
    for (UIImageView *stone in self.stonesArray)
    {
        stoneData = [CURStoneData new];
        stoneData.endNumber = self.endNumber;
        stoneData.stepNumber = self.stepNumber;
        stoneData.isStoneColorRed = stone.image == self.redStone;
        stoneData.stonePositionX = stone.center.x;
        stoneData.stonePositionY = stone.center.y;
        stoneData.hashLink = self.hashLink;
        
        [self.coreDataManager saveStoneData:stoneData];
    }
}

@end
