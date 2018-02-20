//
//  CURCoreDataManagerTests.m
//  CurlingAppTests
//
//  Created by Artem Lomov on 18/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "CURCoreDataManager.h"
#import "CURCoreDataTypesForTests.h"

@interface CURCoreDataManager (CURTests)

@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@interface CURCoreDataManagerTests : XCTestCase

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;
@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@implementation CURCoreDataManagerTests

- (void)setUp {
    [super setUp];
    
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CurlingApp"];
    NSURL *url = NSPersistentContainer.defaultDirectoryURL;
    NSPersistentStoreDescription *description = [NSPersistentStoreDescription persistentStoreDescriptionWithURL:url];
    description.readOnly = YES;
    description.type = NSInMemoryStoreType;
    self.persistentContainer.persistentStoreDescriptions = @[description];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
            abort();
        }
    }];
    self.coreDataContext = self.persistentContainer.viewContext;
    
    self.coreDataManager = OCMPartialMock([CURCoreDataManager new]);
    self.coreDataManager.coreDataContext = self.coreDataContext;
    [self prepareCoreDataForTests];
}

- (void)tearDown {
    self.coreDataManager = nil;
    [super tearDown];
}

- (void)prepareCoreDataForTests
{
    [self loadGameA];
    [self loadGameB];
    [self loadAppData];
}

- (void)loadGameA
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo"
                                                       inManagedObjectContext:self.coreDataContext];
    gameInfo.teamNameFirst = @"A";
    gameInfo.teamNameSecond = @"AA";
    gameInfo.hashLink =  @"AAA";
    gameInfo.numberOfEnds = 1;
    gameInfo.firstTeamScore = 1;
    gameInfo.secondTeamScore = 1;
    gameInfo.isFirstTeamColorRed = YES;
    gameInfo.date = [NSDate date];
    [gameInfo.managedObjectContext save:nil];
    
    EndScore *endScore = [NSEntityDescription insertNewObjectForEntityForName:@"EndScore"
                                                         inManagedObjectContext:self.coreDataContext];
    endScore.hashLink = @"AAA";
    endScore.endNumber = 1;
    endScore.firstTeamScore = 1;
    endScore.secondTeamScore = 1;
    [endScore.managedObjectContext save:nil];
    endScore = [NSEntityDescription insertNewObjectForEntityForName:@"EndScore"
                                             inManagedObjectContext:self.coreDataContext];
    endScore.hashLink = @"AAA";
    endScore.endNumber = 2;
    endScore.firstTeamScore = 2;
    endScore.secondTeamScore = 2;
    [endScore.managedObjectContext save:nil];
    
    [self loadStoneDataForGameA];
}

- (void)loadStoneDataForGameA
{
    StoneData *stoneData = [NSEntityDescription insertNewObjectForEntityForName:@"StoneData"
                                                         inManagedObjectContext:self.coreDataContext];
    stoneData.hashLink = @"AAA";
    stoneData.stonePositionX = 1;
    stoneData.stonePositionY = 1;
    stoneData.stepNumber = 1;
    stoneData.isStoneColorRed = YES;
    stoneData.endNumber =1;
    [stoneData.managedObjectContext save:nil];
    
    stoneData = [NSEntityDescription insertNewObjectForEntityForName:@"StoneData"
                                              inManagedObjectContext:self.coreDataContext];
    stoneData.hashLink = @"AAA";
    stoneData.stonePositionX = 2;
    stoneData.stonePositionY = 2;
    stoneData.stepNumber = 2;
    stoneData.isStoneColorRed = YES;
    stoneData.endNumber = 1;
    [stoneData.managedObjectContext save:nil];
}

- (void)loadGameB
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo"
                                             inManagedObjectContext:self.coreDataContext];
    gameInfo.teamNameFirst = @"B";
    gameInfo.teamNameSecond = @"BB";
    gameInfo.hashLink =  @"BBB";
    gameInfo.numberOfEnds = 2;
    gameInfo.firstTeamScore = 2;
    gameInfo.secondTeamScore = 2;
    gameInfo.isFirstTeamColorRed = YES;
    gameInfo.date = [NSDate date];
    [gameInfo.managedObjectContext save:nil];
}

- (void)loadAppData
{
    AppData *appData = [NSEntityDescription insertNewObjectForEntityForName:@"AppData"
                                                     inManagedObjectContext:self.coreDataContext];
    appData.accessToken = @"access token";
    [appData.managedObjectContext save:nil];
}

- (void)testLoadAllGamesInfo
{
    NSArray<GameInfo *> *data = [self.coreDataManager loadAllGamesInfo];
    
    expect(data.count).to.equal(2);
    expect(data[0].teamNameFirst).to.equal(@"B");
    expect(data[1].teamNameFirst).to.equal(@"A");
}

- (void)testLoadAllStoneData
{
    NSArray<StoneData *> *data = [self.coreDataManager loadAllStoneData];
    
    expect(data.count).to.equal(2);
}

- (void)testLoadAllEndScore
{
    NSArray<EndScore *> *data = [self.coreDataManager loadAllEndScore];
    
    expect(data.count).to.equal(2);
}

- (void)testLoadAppData
{
    AppData *data = [self.coreDataManager loadAppData];
    
    expect(data).notTo.beNil();
    expect(data.accessToken).to.equal(@"access token");
}

- (void)testLoadGamesInfoByHashExist
{
    GameInfo *data = [self.coreDataManager loadGamesInfoByHash:@"BBB"];
    
    expect(data).notTo.beNil();
    expect(data.hashLink).to.equal(@"BBB");
}

- (void)testLoadGamesInfoByHashNotExist
{
    GameInfo *data = [self.coreDataManager loadGamesInfoByHash:@"CCC"];
    
    expect(data).to.beNil();
}

- (void)testLoadStonesDataByHashExist
{
    NSArray<StoneData *> *data = [self.coreDataManager loadStonesDataByHash:@"AAA"];
    
    expect(data.count).to.equal(2);
    expect(data[0].hashLink).to.equal(@"AAA");
}

- (void)testLoadStonesDataByHashNotExist
{
    NSArray<StoneData *> *data = [self.coreDataManager loadStonesDataByHash:@"CCC"];
    
    expect(data.count).to.equal(0);
}

- (void)testLoadStonesDataByHashEndNumberExist
{
    NSArray<StoneData *> *data = [self.coreDataManager loadStonesDataByHash:@"AAA" endNumber:1];
    
    expect(data.count).to.equal(2);
    expect(data[0].stepNumber).to.equal(1);
    expect(data[1].stepNumber).to.equal(2);
}

- (void)testLoadStonesDataByHashEndNumberNotExist
{
    NSArray<StoneData *> *data = [self.coreDataManager loadStonesDataByHash:@"AAA" endNumber:2];
    
    expect(data.count).to.equal(0);
}

- (void)testLoadEndScoreByHashExist
{
    NSArray<EndScore *> *data = [self.coreDataManager loadEndScoreByHash:@"AAA"];
    
    expect(data.count).to.equal(2);
    expect(data[0].endNumber).to.equal(1);
    expect(data[1].endNumber).to.equal(2);
}

- (void)testLoadEndScoreByHashNotExist
{
    NSArray<EndScore *> *data = [self.coreDataManager loadEndScoreByHash:@"CCC"];
    
    expect(data.count).to.equal(0);
}

- (void)testSaveGameInfo
{
    id gameInfoMock = OCMClassMock([CURGameInfo class]);
    GameInfoTest *gameInfoTest = [GameInfoTest new];
    OCMStub([gameInfoMock new]).andReturn(gameInfoTest);
    
    CURGameInfo *gameInfo = [CURGameInfo new];
    gameInfo.teamNameFirst = @"B";
    gameInfo.teamNameSecond = @"BB";
    gameInfo.hashLink =  @"test";
    gameInfo.numberOfEnds = 2;
    gameInfo.firstTeamScore = 2;
    gameInfo.secondTeamScore = 2;
    gameInfo.isFirstTeamColorRed = YES;
    gameInfo.date = [NSDate date];
    
    [self.coreDataManager saveGameInfo:gameInfo];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"test"];
    fetchRequest.predicate = predicate;
    NSArray<GameInfo *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(1);
    expect(data[0].teamNameFirst).to.equal(@"B");
    expect(data[0].teamNameSecond).to.equal(@"BB");
    expect(data[0].numberOfEnds).to.equal(2);
    expect(data[0].firstTeamScore).to.equal(2);
    expect(data[0].secondTeamScore).to.equal(2);
    expect(data[0].isFirstTeamColorRed).to.equal(1);
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
}

- (void)testSaveStoneData
{
    id gameInfoMock = OCMClassMock([CURStoneData class]);
    StoneDataTest *stoneDataTest = [StoneDataTest new];
    OCMStub([gameInfoMock new]).andReturn(stoneDataTest);
    
    CURStoneData *stoneData = [CURStoneData new];
    stoneData.hashLink = @"test";
    stoneData.stonePositionX = 1;
    stoneData.stonePositionY = 1;
    stoneData.stepNumber = 1;
    stoneData.isStoneColorRed = YES;
    stoneData.endNumber =1;
    
    [self.coreDataManager saveStoneData:stoneData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"test"];
    fetchRequest.predicate = predicate;
    NSArray<StoneData *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(1);
    expect(data[0].stonePositionX).to.equal(1);
    expect(data[0].stonePositionY).to.equal(1);
    expect(data[0].stepNumber).to.equal(1);
    expect(data[0].endNumber).to.equal(1);
    expect(data[0].isStoneColorRed).to.equal(1);
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
}

- (void)testSaveNumberOfEndsForHash
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo"
                                                       inManagedObjectContext:self.coreDataContext];
    gameInfo.hashLink = @"test";
    
    OCMStub([self.coreDataManager loadGamesInfoByHash:[OCMArg any]]).andReturn(gameInfo);
    
    [self.coreDataManager saveNumberOfEnds:33 forHash:@"test"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"test"];
    fetchRequest.predicate = predicate;
    NSArray<GameInfo *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(1);
    expect(data[0].numberOfEnds).to.equal(33);
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
}

- (void)testSaveFirstScoreSecondScoreForHash
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo"
                                                       inManagedObjectContext:self.coreDataContext];
    gameInfo.hashLink = @"test";
    
    OCMStub([self.coreDataManager loadGamesInfoByHash:[OCMArg any]]).andReturn(gameInfo);
    
    [self.coreDataManager saveFirstScore:11 secondScore:22 forHash:@"test"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"test"];
    fetchRequest.predicate = predicate;
    NSArray<GameInfo *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(1);
    expect(data[0].firstTeamScore).to.equal(11);
    expect(data[0].secondTeamScore).to.equal(22);
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
}

- (void)testSaveFirstScoreSecondScoreForEndHash
{
    [self.coreDataManager saveFirstScore:1 secondScore:1 forEnd:1 hash:@"test"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"test"];
    fetchRequest.predicate = predicate;
    NSArray<EndScore *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(1);
    expect(data[0].firstTeamScore).to.equal(1);
    expect(data[0].secondTeamScore).to.equal(1);
    expect(data[0].endNumber).to.equal(1);
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
}

- (void)testSaveAccessTokenNoToken
{
    BOOL result = [self.coreDataManager saveAccessToken:nil];
    
    expect(result).to.beFalsy();
}

- (void)testSaveAccessTokenEmptyCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AppData"];
    NSArray<AppData *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
    
    OCMStub([self.coreDataManager loadAppData]).andReturn(nil);
    
    BOOL result = [self.coreDataManager saveAccessToken:@"test"];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AppData"];
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(result).to.beTruthy();
    expect(data.count).to.equal(1);
    expect(data[0].accessToken).to.equal(@"test");
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
    
    [self loadAppData];
}

- (void)testSaveAccessTokenUpdateToken
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AppData"];
    NSArray<AppData *> *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    AppData *appData = data.firstObject;
    
    OCMStub([self.coreDataManager loadAppData]).andReturn(appData);
    
    BOOL result = [self.coreDataManager saveAccessToken:@"test"];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AppData"];
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(result).to.beTruthy();
    expect(data.count).to.equal(1);
    expect(data[0].accessToken).to.equal(@"test");
    
    [self.coreDataContext deleteObject:data[0]];
    [self.coreDataContext save:nil];
    
    [self loadAppData];
}

- (void)testDeleteGameByHash
{
    [self.coreDataManager deleteGameByHash:@"AAA"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", @"AAA"];
    fetchRequest.predicate = predicate;
    NSArray *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    fetchRequest.predicate = predicate;
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
    fetchRequest.predicate = predicate;
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    [self loadGameA];
}

- (void)testDeleteEndByHashEndNumber
{
    [self.coreDataManager deleteEndByHash:@"AAA" endNumber:1];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@ AND endNumber == %@", @"AAA", @1];
    fetchRequest.predicate = predicate;
    NSArray *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    [self loadStoneDataForGameA];
}

- (void)testClearCoreData
{
    [self.coreDataManager clearCoreData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSArray *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
    data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    expect(data.count).to.equal(0);
    
    [self loadGameA];
    [self loadGameB];
}

@end
