//
//  CURShowGameManagerTests.m
//  CurlingAppTests
//
//  Created by Artem Lomov on 18/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "CURShowGameManager.h"
#import "CURScoreView.h"
#import "CURCoreDataTypesForTests.h"

@interface CURShowGameManager (CURTests)

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

- (void)startNewEnd;

@end

@interface CURShowGameManagerTests : XCTestCase

@property (nonatomic, strong) CURShowGameManager *showGameManager;

@end

@implementation CURShowGameManagerTests

- (void)setUp {
    [super setUp];
    self.showGameManager = OCMPartialMock([CURShowGameManager new]);
}

- (void)tearDown {
    self.showGameManager = nil;
    [super tearDown];
}

- (void)testStartNewEndFirstRedStone
{
    NSInteger endNumber = 1;
    self.showGameManager.endNumber = endNumber;
    
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate setEndNumber:endNumber]);
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.showGameManager.coreDataManager = coreDataManager;
    
    StoneDataTest *stone = [StoneDataTest new];
    stone.isStoneColorRed = YES;
    NSArray<StoneDataTest *> *arr = @[stone];
    OCMStub([coreDataManager loadStonesDataByHash:[OCMArg any] endNumber:endNumber]).andReturn(arr);
    
    OCMStub([self.showGameManager showNextStep]);
    
    [self.showGameManager startShowGame];
    
    OCMVerify([self.showGameManager showNextStep]);
    expect(self.showGameManager.stoneColor).to.equal(CURRedColor);
    expect(self.showGameManager.stepNumber).to.equal(0);
    expect(self.showGameManager.indexInStonesData).to.equal(0);
}

- (void)testStartNewEndFirstYellowStone
{
    NSInteger endNumber = 1;
    self.showGameManager.endNumber = endNumber;
    
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate setEndNumber:endNumber]);
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.showGameManager.coreDataManager = coreDataManager;
    
    StoneDataTest *stone = [StoneDataTest new];
    stone.isStoneColorRed = NO;
    NSArray<StoneDataTest *> *arr = @[stone];
    OCMStub([coreDataManager loadStonesDataByHash:[OCMArg any] endNumber:endNumber]).andReturn(arr);
    
    OCMStub([self.showGameManager showNextStep]);
    
    [self.showGameManager startShowGame];
    
    expect(self.showGameManager.stoneColor).to.equal(CURYellowColor);
}

- (void)testStartShowGame
{
    NSInteger stoneSize = 10;
    self.showGameManager.stoneSize = stoneSize;
    
    OCMStub([self.showGameManager startNewEnd]);
    
    NSArray<UIImageView *> *stones = [self.showGameManager startShowGame];

    OCMVerify([self.showGameManager startNewEnd]);
    expect(stones.count).to.equal(CURShowGameManagerNumberOfStonesPerEnd);
    expect(stones[0].frame.size.width).to.equal(stoneSize);
    expect(stones[0].frame.size.height).to.equal(stoneSize);
    expect(stones[0].userInteractionEnabled).to.beTruthy();
    expect(stones[0].hidden).to.beTruthy();
    expect(stones[0].layer.cornerRadius).to.equal(stoneSize/2.);
}

- (void)testChangeEndByNumberFirstEnd
{
    NSInteger endNumber = 0;
    NSInteger numberOfEnds = 5;
    self.showGameManager.endNumber = endNumber;
    self.showGameManager.numberOfEnds = numberOfEnds;
    
    UIImageView *stone = [UIImageView new];
    NSArray *stonesArray = @[stone];
    self.showGameManager.stonesArray = stonesArray;
    
    OCMStub([self.showGameManager startNewEnd]);
    
    NSInteger changeNumber = 1;
    BOOL result = [self.showGameManager changeEndByNumber:changeNumber];
    
    OCMVerify([self.showGameManager startNewEnd]);
    expect(self.showGameManager.endNumber).to.equal(endNumber+changeNumber);
    expect(self.showGameManager.stonesArray[0].hidden).to.beTruthy();
    expect(result).to.beTruthy();
}

- (void)testChangeEndByNumberLastEnd
{
    NSInteger endNumber = 1;
    NSInteger numberOfEnds = 5;
    self.showGameManager.endNumber = endNumber;
    self.showGameManager.numberOfEnds = numberOfEnds;
    
    OCMStub([self.showGameManager startNewEnd]);
    
    NSInteger changeNumber = 4;
    BOOL result = [self.showGameManager changeEndByNumber:changeNumber];
    
    expect(result).to.beTruthy();
}

- (void)testChangeEndByNumberMiddleEnd
{
    NSInteger endNumber = 1;
    NSInteger numberOfEnds = 5;
    self.showGameManager.endNumber = endNumber;
    self.showGameManager.numberOfEnds = numberOfEnds;
    
    OCMStub([self.showGameManager startNewEnd]);
    
    NSInteger changeNumber = 2;
    BOOL result = [self.showGameManager changeEndByNumber:changeNumber];
    
    expect(result).to.beFalsy();
}

- (void)prepareTestShowStep
{
    UIImageView *stone = nil;
    NSMutableArray *stonesArray = [NSMutableArray new];
    for(int i = 0; i<CURShowGameManagerNumberOfStonesPerEnd; i++)
    {
        stone = [UIImageView new];
        [stonesArray addObject:stone];
    }
    self.showGameManager.stonesArray = [stonesArray copy];
    
    StoneDataTest *stoneData1 = [[StoneDataTest alloc] initWithStepNumber:1 position:CGPointMake(1, 1) isRedColor:YES];
    StoneDataTest *stoneData2 = [[StoneDataTest alloc] initWithStepNumber:2 position:CGPointMake(2, 2) isRedColor:NO];
    StoneDataTest *stoneData3 = [[StoneDataTest alloc] initWithStepNumber:2 position:CGPointMake(2, 2) isRedColor:NO];
    StoneDataTest *stoneData4 = [[StoneDataTest alloc] initWithStepNumber:3 position:CGPointMake(3, 3) isRedColor:YES];
    StoneDataTest *stoneData5 = [[StoneDataTest alloc] initWithStepNumber:3 position:CGPointMake(3, 3) isRedColor:YES];
    NSArray *stonesData = @[stoneData1, stoneData2, stoneData3, stoneData4, stoneData5];
    self.showGameManager.stonesData = stonesData;
    
    self.showGameManager.redStone = [UIImage imageNamed:@"stone_red"];
    self.showGameManager.yellowStone = [UIImage imageNamed:@"stone_yellow"];
    
    self.showGameManager.stoneColor = CURRedColor;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURRedColor byNumber:-1]);
}

- (void)testShowNextStepFirstStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 0;
    self.showGameManager.stepNumber = 0;
    
    [self.showGameManager showNextStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(1);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(1);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
}

- (void)testShowNextStepMiddleStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 0;
    self.showGameManager.stepNumber = 1;
    
    [self.showGameManager showNextStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(2);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(2);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_yellow"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.stonesArray[1].center.x).to.equal(2);
    expect(self.showGameManager.stonesArray[1].center.y).to.equal(2);
    expect(self.showGameManager.stonesArray[1].image).to.equal([UIImage imageNamed:@"stone_yellow"]);
    expect(self.showGameManager.stonesArray[1].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
}

- (void)testShowNextStepLastStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 0;
    self.showGameManager.stepNumber = 2;
    
    [self.showGameManager showNextStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(3);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(3);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.stonesArray[1].center.x).to.equal(3);
    expect(self.showGameManager.stonesArray[1].center.y).to.equal(3);
    expect(self.showGameManager.stonesArray[1].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[1].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
}

- (void)testShowNextStepRedStone
{
    self.showGameManager.stepNumber = CURShowGameManagerNumberOfStonesPerEnd - 2;
    self.showGameManager.stoneColor = CURRedColor;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURRedColor byNumber:-1]);
    
    BOOL result = [self.showGameManager showNextStep];
    
    OCMVerify([delegate changeScoreForColor:CURRedColor byNumber:-1]);
    expect(self.showGameManager.stoneColor).to.equal(CURYellowColor);
    expect(result).to.beFalsy();
}

- (void)testShowNextStepYellowStone
{
    self.showGameManager.stepNumber = CURShowGameManagerNumberOfStonesPerEnd - 1;
    self.showGameManager.stoneColor = CURYellowColor;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURYellowColor byNumber:-1]);
    
    BOOL result = [self.showGameManager showNextStep];
    
    OCMVerify([delegate changeScoreForColor:CURYellowColor byNumber:-1]);
    expect(self.showGameManager.stoneColor).to.equal(CURRedColor);
    expect(result).to.beTruthy();
}

- (void)testShowPreviousStepFirstStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 4;
    self.showGameManager.stepNumber = 2;
    
    [self.showGameManager showPreviousStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(1);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(1);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
    expect(self.showGameManager.stonesArray[1].hidden).to.beTruthy();
    expect(self.showGameManager.stonesArray[CURShowGameManagerNumberOfStonesPerEnd-1].hidden).to.beTruthy();
}

- (void)testShowPreviousStepMiddleStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 4;
    self.showGameManager.stepNumber = 3;
    
    [self.showGameManager showPreviousStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(2);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(2);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_yellow"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.stonesArray[1].center.x).to.equal(2);
    expect(self.showGameManager.stonesArray[1].center.y).to.equal(2);
    expect(self.showGameManager.stonesArray[1].image).to.equal([UIImage imageNamed:@"stone_yellow"]);
    expect(self.showGameManager.stonesArray[1].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
    expect(self.showGameManager.stonesArray[2].hidden).to.beTruthy();
    expect(self.showGameManager.stonesArray[CURShowGameManagerNumberOfStonesPerEnd-1].hidden).to.beTruthy();
}

- (void)testShowPreviousStepLastStep
{
    [self prepareTestShowStep];
    
    self.showGameManager.indexInStonesData = 4;
    self.showGameManager.stepNumber = 4;
    
    [self.showGameManager showPreviousStep];
    
    expect(self.showGameManager.stonesArray[0].center.x).to.equal(3);
    expect(self.showGameManager.stonesArray[0].center.y).to.equal(3);
    expect(self.showGameManager.stonesArray[0].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[0].hidden).to.beFalsy();
    expect(self.showGameManager.stonesArray[1].center.x).to.equal(3);
    expect(self.showGameManager.stonesArray[1].center.y).to.equal(3);
    expect(self.showGameManager.stonesArray[1].image).to.equal([UIImage imageNamed:@"stone_red"]);
    expect(self.showGameManager.stonesArray[1].hidden).to.beFalsy();
    expect(self.showGameManager.indexInStonesData).beInTheRangeOf(0, 4);
    expect(self.showGameManager.stonesArray[2].hidden).to.beTruthy();
    expect(self.showGameManager.stonesArray[CURShowGameManagerNumberOfStonesPerEnd-1].hidden).to.beTruthy();
}

- (void)testShowPreviousStepRedStone
{
    self.showGameManager.stepNumber = 3;
    self.showGameManager.stoneColor = CURRedColor;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURYellowColor byNumber:1]);
    
    BOOL result = [self.showGameManager showPreviousStep];
    
    OCMVerify([delegate changeScoreForColor:CURYellowColor byNumber:1]);
    expect(self.showGameManager.stoneColor).to.equal(CURYellowColor);
    expect(result).to.beFalsy();
}

- (void)testShowPreviousStepYellowStone
{
    self.showGameManager.stepNumber = 2;
    self.showGameManager.stoneColor = CURYellowColor;
    id<CURChangeScoreProtocol> delegate = OCMClassMock([CURScoreView class]);
    self.showGameManager.output = delegate;
    OCMStub([delegate changeScoreForColor:CURRedColor byNumber:1]);
    
    BOOL result = [self.showGameManager showPreviousStep];
    
    OCMVerify([delegate changeScoreForColor:CURRedColor byNumber:1]);
    expect(self.showGameManager.stoneColor).to.equal(CURRedColor);
    expect(result).to.beTruthy();
}

- (void)testIsFirstEndYes
{
    self.showGameManager.endNumber = 1;
    self.showGameManager.numberOfEnds = 3;
    
    BOOL result = [self.showGameManager isFirstEnd];
    
    expect(result).to.beTruthy();
}

- (void)testIsFirstEndNo
{
    self.showGameManager.endNumber = 3;
    self.showGameManager.numberOfEnds = 3;
    
    BOOL result = [self.showGameManager isFirstEnd];
    
    expect(result).to.beFalsy();
}

- (void)testIsLastEndYes
{
    self.showGameManager.endNumber = 3;
    self.showGameManager.numberOfEnds = 3;
    
    BOOL result = [self.showGameManager isLastEnd];
    
    expect(result).to.beTruthy();
}

- (void)testIsLastEndNo
{
    self.showGameManager.endNumber = 1;
    self.showGameManager.numberOfEnds = 3;
    
    BOOL result = [self.showGameManager isLastEnd];
    
    expect(result).to.beFalsy();
}

@end
