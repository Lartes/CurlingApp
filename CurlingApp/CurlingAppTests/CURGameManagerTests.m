//
//  CURGameManagerTests.m
//  CurlingAppTests
//
//  Created by Artem Lomov on 17/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "CURGameManager.h"
#import "CURScoreView.h"
#import "CURCoreDataTypesForTests.h"

@interface CURGameManager (CURTests)

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

- (void)saveToCoreData;

@end

@interface CURGameManagerTests : XCTestCase

@property (nonatomic, strong) CURGameManager *gameManager;

@end

@implementation CURGameManagerTests

- (void)setUp {
    [super setUp];
    self.gameManager = OCMPartialMock([CURGameManager new]);
}

- (void)tearDown {
    self.gameManager = nil;
    [super tearDown];
}

- (void)testAddStoneNeedSaveData
{
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:@1];
    self.gameManager.stonesArray = array;
    
    OCMStub([self.gameManager saveToCoreData]);
    
    [self.gameManager addStone];
    
    OCMVerify([self.gameManager saveToCoreData]);
}

- (void)testAddStoneNotNeedSaveData
{
    NSMutableArray *array = [NSMutableArray new];
    self.gameManager.stonesArray = array;
    
    OCMReject([self.gameManager saveToCoreData]);
    
    [self.gameManager addStone];
}

- (void)testAddStoneCurrentRedStone
{
    self.gameManager.stoneColor = CURRedColor;
    self.gameManager.redStone = [UIImage imageNamed:@"stone_red"];
    OCMStub([self.gameManager saveToCoreData]);
    
    UIImageView *stone = [self.gameManager addStone];
    
    expect(stone.image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.gameManager.stoneColor).to.equal(CURYellowColor);
}

- (void)testAddStoneCurrentYellowStone
{
    self.gameManager.stoneColor = CURYellowColor;
    self.gameManager.yellowStone = [UIImage imageNamed:@"stone_yellow"];
    OCMStub([self.gameManager saveToCoreData]);
    
    UIImageView *stone = [self.gameManager addStone];
    
    expect(stone.image).to.equal([UIImage imageNamed:@"stone_yellow"]);
    expect(self.gameManager.stoneColor).to.equal(CURRedColor);
}

- (void)testAddStone
{
    NSMutableArray *array = [NSMutableArray new];
    self.gameManager.stonesArray = array;
    NSInteger stoneSize = 10;
    self.gameManager.stoneSize = stoneSize;
    self.gameManager.stoneColor = CURRedColor;
    OCMStub([self.gameManager saveToCoreData]);
    
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.gameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURRedColor byNumber:-1]).andReturn(NO);
    
    UIImageView *stone = [self.gameManager addStone];
    
    OCMVerify([delegate changeScoreForColor:CURRedColor byNumber:-1]);
    expect(stone.frame.size).to.equal(CGSizeMake(stoneSize, stoneSize));
    expect(stone.userInteractionEnabled).to.beTruthy();
    expect(stone.layer.cornerRadius).to.equal(stoneSize/2.);
    expect(self.gameManager.isEndFinishedBool).to.beFalsy();
    expect(self.gameManager.stonesArray.firstObject).to.equal(stone);
}

- (void)testStartEnd
{
    NSInteger endNumber = 1;
    self.gameManager.endNumber = endNumber;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.gameManager.output = delegate;
    OCMStub([delegate setEndNumber:endNumber]);
    
    [self.gameManager startEnd];
    
    OCMVerify([delegate setEndNumber:2]);
    OCMVerify([self.gameManager.stonesArray removeAllObjects]);
    expect(self.gameManager.isEndFinishedBool).to.beFalsy();
    expect(self.gameManager.stepNumber).to.equal(1);
    expect(self.gameManager.endNumber).to.equal(endNumber+1);
}

- (void)testFinishEnd
{
    OCMStub([self.gameManager saveToCoreData]);
    
    [self.gameManager finishEnd];
    
    OCMVerify([self.gameManager saveToCoreData]);
}

- (void)testFinishGame
{
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.gameManager.coreDataManager = coreDataManager;
    NSInteger endNumber = 1;
    self.gameManager.endNumber = endNumber;
    self.gameManager.hashLink = @"qwerty";
    
    EndScoreTest *score1 = [EndScoreTest new];
    score1.firstTeamScore = 1;
    score1.secondTeamScore = 0;
    EndScoreTest *score2 = [EndScoreTest new];
    score2.firstTeamScore = 0;
    score2.secondTeamScore = 5;
    NSArray<EndScoreTest *> *endScores= @[score1, score2];
    OCMStub([coreDataManager loadEndScoreByHash:[OCMArg any]]).andReturn(endScores);
    
    OCMStub([coreDataManager saveNumberOfEnds:endNumber forHash:[OCMArg any]]);
    OCMStub([coreDataManager saveFirstScore:1 secondScore:5 forHash:[OCMArg any]]);
    
    [self.gameManager finishGame];
    
    OCMVerify([coreDataManager saveFirstScore:1 secondScore:5 forHash:@"qwerty"]);
    OCMVerify([coreDataManager saveNumberOfEnds:endNumber forHash:@"qwerty"]);
}

- (void)testIsEndFinishedYes
{
    self.gameManager.isEndFinishedBool = YES;
    
    BOOL result = [self.gameManager isEndFinished];
    
    expect(result).to.beTruthy();
}

- (void)testIsEndFinishedNo
{
    self.gameManager.isEndFinishedBool = NO;
    
    BOOL result = [self.gameManager isEndFinished];
    
    expect(result).to.beFalsy();
}

- (void)testGetHashLink
{
    self.gameManager.hashLink = @"qwerty";
    
    NSString *result = [self.gameManager getHashLink];
    
    expect(result).to.equal(@"qwerty");
}

- (void)testGetEndNumber
{
    self.gameManager.endNumber = 1;
    
    NSInteger result = [self.gameManager getEndNumber];
    
    expect(result).to.equal(1);
}

- (void)testGetFirstTeamColor
{
    self.gameManager.firstTeamColor = CURRedColor;
    
    CURColors result = [self.gameManager getFirstTeamColor];
    
    expect(result).to.equal(CURRedColor);
}

- (void)testSetFirstStoneColor
{
    [self.gameManager setFirstStoneColor:CURRedColor];
    
    expect(self.gameManager.stoneColor).to.equal(CURRedColor);
}

- (void)testSaveToCoreDataEmptyData
{
    NSMutableArray *stonesArray = [NSMutableArray new];
    self.gameManager.stonesArray = stonesArray;
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.gameManager.coreDataManager = coreDataManager;
    OCMReject([coreDataManager saveStoneData:[OCMArg any]]);
    
    [self.gameManager saveToCoreData];
}

- (void)testSaveToCoreData
{
    UIImageView *image1 = [UIImageView new];
    image1.center = CGPointMake(11, 13);
    image1.image = [UIImage imageNamed:@"stone_red"];
    NSMutableArray<UIImageView *> *stonesArray = [@[image1] mutableCopy];
    self.gameManager.stonesArray = stonesArray;
    self.gameManager.redStone = image1.image;
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.gameManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager saveStoneData:[OCMArg any]]);
    
    id stoneData = OCMClassMock([CURStoneData class]);
    StoneDataTest *testData = [StoneDataTest new];
    OCMStub([stoneData new]).andReturn(testData);
    
    [self.gameManager saveToCoreData];
    
    OCMVerify([coreDataManager saveStoneData:[OCMArg checkWithBlock:^BOOL(id obj){
        StoneDataTest *data = obj;
        if (data.stonePositionX != 11)
        {
            return NO;
        }
        if (data.stonePositionY != 13)
        {
            return NO;
        }
        if (!data.isStoneColorRed)
        {
            return NO;
        }
        return YES;
    }]]);
}

@end
