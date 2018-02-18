//
//  CURNetworkManagerTests.m
//  CurlingAppTests
//
//  Created by Artem Lomov on 18/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import <OHHTTPStubs.h>
#import <OHPathHelpers.h>
#import "CURNetworkManager.h"
#import "CURSettingsViewController.h"
#import "CURCoreDataTypesForTests.h"

@interface CURNetworkManager (CURTests)

- (void)sendUploadRequestWithData:(NSData *)dataJSON;
- (void)saveDownloadDataToCoreData:(NSURL *)location;

@end

@interface CURNetworkManagerTests : XCTestCase

@property (nonatomic, strong) CURNetworkManager *networkManager;

@end

@implementation CURNetworkManagerTests

- (void)setUp {
    [super setUp];
    self.networkManager = OCMPartialMock([CURNetworkManager new]);
}

- (void)tearDown {
    self.networkManager = nil;
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testSaveToDropbox
{
    GameInfoTest *gameInfo = [GameInfoTest new];
    gameInfo.teamNameFirst = @"string";
    gameInfo.teamNameSecond = @"string";
    gameInfo.hashLink =  @"string";
    gameInfo.numberOfEnds = 3;
    gameInfo.firstTeamScore = 3;
    gameInfo.secondTeamScore = 3;
    gameInfo.isFirstTeamColorRed = YES;
    NSArray *gamesInfo = @[gameInfo];
    
    StoneDataTest *stoneData = [StoneDataTest new];
    stoneData.hashLink = @"string";
    stoneData.stonePositionX = 3;
    stoneData.stonePositionY = 3;
    stoneData.stepNumber = 3;
    stoneData.isStoneColorRed = YES;
    stoneData.endNumber = 3;
    NSArray *stonesData = @[stoneData];
    
    EndScoreTest *endScore = [EndScoreTest new];
    endScore.hashLink = @"string";
    endScore.endNumber = 3;
    endScore.firstTeamScore = 3;
    endScore.secondTeamScore = 3;
    NSArray *endsScore = @[endScore];
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager loadAllGamesInfo]).andReturn(gamesInfo);
    OCMStub([coreDataManager loadAllStoneData]).andReturn(stonesData);
    OCMStub([coreDataManager loadAllEndScore]).andReturn(endsScore);
    
    OCMStub([self.networkManager sendUploadRequestWithData:[OCMArg any]]);
    
    [self.networkManager saveToDropbox];
    
    OCMVerify([self.networkManager sendUploadRequestWithData:[OCMArg checkWithBlock:^BOOL(id obj){
        NSData *dataJSON = obj;
        NSDictionary* readData = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingAllowFragments error:nil];
        NSArray<NSDictionary *> *gamesInfo = readData[@"GameInfo"];
        if (![gamesInfo[0][@"teamNameFirst"] isEqual:@"string"])
        {
            return NO;
        }
        if (![gamesInfo[0][@"teamNameSecond"] isEqual:@"string"])
        {
            return NO;
        }
        if (![gamesInfo[0][@"hashLink"] isEqual:@"string"])
        {
            return NO;
        }
        if (![gamesInfo[0][@"numberOfEnds"] isEqual:@3])
        {
            return NO;
        }
        if (![gamesInfo[0][@"firstTeamScore"] isEqual:@3])
        {
            return NO;
        }
        if (![gamesInfo[0][@"secondTeamScore"] isEqual:@3])
        {
            return NO;
        }
        if (![gamesInfo[0][@"isFirstTeamColorRed"] isEqual:@YES])
        {
            return NO;
        }
 
        NSArray<NSDictionary *> *stonesInfo = readData[@"StoneData"];
        if (![stonesInfo[0][@"hashLink"] isEqual:@"string"])
        {
            return NO;
        }
        if (![stonesInfo[0][@"stonePositionX"] isEqual:@3])
        {
            return NO;
        }
        if (![stonesInfo[0][@"stonePositionY"] isEqual:@3])
        {
            return NO;
        }
        if (![stonesInfo[0][@"stepNumber"] isEqual:@3])
        {
            return NO;
        }
        if (![stonesInfo[0][@"endNumber"] isEqual:@3])
        {
            return NO;
        }
        if (![stonesInfo[0][@"isStoneColorRed"] isEqual:@YES])
        {
            return NO;
        }

        NSArray<NSDictionary *> *endsScore = readData[@"EndScore"];
        if (![endsScore[0][@"hashLink"] isEqual:@"string"])
        {
            return NO;
        }
        if (![endsScore[0][@"endNumber"] isEqual:@3])
        {
            return NO;
        }
        if (![endsScore[0][@"firstTeamScore"] isEqual:@3])
        {
            return NO;
        }
        if (![endsScore[0][@"secondTeamScore"] isEqual:@3])
        {
            return NO;
        }
        
        return YES;
    }]]);
}

- (void)testSaveDownloadDataToCoreData
{
    NSMutableDictionary *dict = nil;
    
    dict = [NSMutableDictionary new];
    dict[@"teamNameFirst"] = @"string";
    dict[@"teamNameSecond"] = @"string";
    dict[@"hashLink"] = @"string";
    dict[@"numberOfEnds"] = @(3);
    dict[@"firstTeamScore"] = @(3);
    dict[@"secondTeamScore"] = @(3);
    dict[@"isFirstTeamColorRed"] = @(YES);
    NSArray *gamesInfo = @[[dict copy]];
    
    dict = [NSMutableDictionary new];
    dict[@"hashLink"] = @"string";
    dict[@"stonePositionX"] = @(3);
    dict[@"stonePositionY"] = @(3);
    dict[@"stepNumber"] = @(3);
    dict[@"isStoneColorRed"] = @(YES);
    dict[@"endNumber"] = @(3);
    NSArray *stonesData = @[[dict copy]];
    
    dict = [NSMutableDictionary new];
    dict[@"hashLink"] = @"string";
    dict[@"endNumber"] = @(3);
    dict[@"firstTeamScore"] = @(3);
    dict[@"secondTeamScore"] = @(3);
    NSArray *endsScore = @[[dict copy]];
    
    NSDictionary *dataToSave = @{
        @"GameInfo":gamesInfo,
        @"StoneData":stonesData,
        @"EndScore":endsScore
    };
    
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:dataToSave options:NSJSONWritingSortedKeys error:nil];
    
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager clearCoreData]);
    OCMStub([coreDataManager saveGameInfo:[OCMArg any]]);
    OCMStub([coreDataManager saveStoneData:[OCMArg any]]);
    OCMStub([coreDataManager saveFirstScore:3 secondScore:3 forEnd:3 hash:[OCMArg any]]);
    
    id gameInfo = OCMClassMock([CURGameInfo class]);
    GameInfoTest *gameInfoTest = [GameInfoTest new];
    OCMStub([gameInfo new]).andReturn(gameInfoTest);
    
    id stoneData = OCMClassMock([CURStoneData class]);
    StoneDataTest *stoneDataTest = [StoneDataTest new];
    OCMStub([stoneData new]).andReturn(stoneDataTest);
    
    id nsData = OCMClassMock([NSData class]);
    OCMStub([nsData dataWithContentsOfURL:[OCMArg any]]).andReturn(dataJSON);
    
    [self.networkManager saveDownloadDataToCoreData:nil];
    
    OCMVerify([coreDataManager saveGameInfo:[OCMArg checkWithBlock:^BOOL(id obj){
        GameInfoTest *data = obj;
        if(![data.teamNameFirst isEqual:@"string"])
        {
            return NO;
        }
        if(![data.teamNameSecond isEqual:@"string"])
        {
            return NO;
        }
        if(![data.hashLink isEqual:@"string"])
        {
            return NO;
        }
        if(data.numberOfEnds != 3)
        {
            return NO;
        }
        if(data.firstTeamScore != 3)
        {
            return NO;
        }
        if(data.secondTeamScore != 3)
        {
            return NO;
        }
        if(!data.isFirstTeamColorRed)
        {
            return NO;
        }
        return YES;
    }]]);
    OCMVerify([coreDataManager saveStoneData:[OCMArg checkWithBlock:^BOOL(id obj){
        StoneDataTest *data = obj;
        if(![data.hashLink isEqual:@"string"])
        {
            return NO;
        }
        if(data.endNumber != 3)
        {
            return NO;
        }
        if(data.stepNumber != 3)
        {
            return NO;
        }
        if(data.stonePositionX != 3)
        {
            return NO;
        }
        if(data.stonePositionY != 3)
        {
            return NO;
        }
        if(!data.isStoneColorRed)
        {
            return NO;
        }
        return YES;
    }]]);
    OCMVerify([coreDataManager saveFirstScore:3 secondScore:3 forEnd:3 hash:@"string"]);
}

- (void)testSendUploadRequestWithDataSucceded
{
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager loadAppData]);
    
    id<CURNetworkManagerProtocol> delegate = OCMClassMock([CURSettingsViewController class]);
    self.networkManager.output = delegate;
    OCMStub([delegate taskDidFinishedWithStatus:[OCMArg any]]);
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://content.dropboxapi.com/2/files/upload"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *fixture = OHPathForFile(@"wsresponse.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation* responseArrived = [self expectationWithDescription:@"response"];
    
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:@{@"1":@"1"} options:NSJSONWritingSortedKeys error:nil];
    
    [self.networkManager sendUploadRequestWithData:dataJSON];
    
    XCTWaiterResult waitResult = [XCTWaiter waitForExpectations:@[responseArrived] timeout:1.];
    OCMVerify([delegate taskDidFinishedWithStatus:YES]);
}

- (void)testSendUploadRequestWithDataNotSucceded
{
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager loadAppData]);
    
    id<CURNetworkManagerProtocol> delegate = OCMClassMock([CURSettingsViewController class]);
    self.networkManager.output = delegate;
    OCMStub([delegate taskDidFinishedWithStatus:[OCMArg any]]);
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://content.dropboxapi.com/2/files/upload"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *fixture = OHPathForFile(@"wsresponse.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:400
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation* responseArrived = [self expectationWithDescription:@"response"];
    
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:@{@"1":@"1"} options:NSJSONWritingSortedKeys error:nil];
    
    [self.networkManager sendUploadRequestWithData:dataJSON];
    
    XCTWaiterResult waitResult = [XCTWaiter waitForExpectations:@[responseArrived] timeout:1.];
    OCMVerify([delegate taskDidFinishedWithStatus:NO]);
}

- (void)testLoadFromDropboxSucceded
{
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager loadAppData]);
    
    id<CURNetworkManagerProtocol> delegate = OCMClassMock([CURSettingsViewController class]);
    self.networkManager.output = delegate;
    OCMStub([delegate taskDidFinishedWithStatus:[OCMArg any]]);
    OCMStub([self.networkManager saveDownloadDataToCoreData:[OCMArg any]]);
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://content.dropboxapi.com/2/files/download"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *fixture = OHPathForFile(@"wsresponse.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:200
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation* responseArrived = [self expectationWithDescription:@"response"];
    
    [self.networkManager loadFromDropbox];
    
    XCTWaiterResult waitResult = [XCTWaiter waitForExpectations:@[responseArrived] timeout:1.];
    OCMVerify([delegate taskDidFinishedWithStatus:YES]);
}

- (void)testLoadFromDropboxNotSucceded
{
    id coreDataManager = OCMClassMock([CURCoreDataManager class]);
    self.networkManager.coreDataManager = coreDataManager;
    OCMStub([coreDataManager loadAppData]);
    
    id<CURNetworkManagerProtocol> delegate = OCMClassMock([CURSettingsViewController class]);
    self.networkManager.output = delegate;
    OCMStub([delegate taskDidFinishedWithStatus:[OCMArg any]]);
    OCMStub([self.networkManager saveDownloadDataToCoreData:[OCMArg any]]);
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"https://content.dropboxapi.com/2/files/download"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *fixture = OHPathForFile(@"wsresponse.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                statusCode:400
                                                   headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation* responseArrived = [self expectationWithDescription:@"response"];
    
    [self.networkManager loadFromDropbox];
    
    XCTWaiterResult waitResult = [XCTWaiter waitForExpectations:@[responseArrived] timeout:1.];
    OCMVerify([delegate taskDidFinishedWithStatus:NO]);
}

- (void)testLoginToDropbox
{
    UIApplication *app = OCMPartialMock([UIApplication sharedApplication]);
    OCMStub([app openURL:[OCMArg any] options:[OCMArg any] completionHandler:nil]);
    
    [self.networkManager loginToDropbox];
    
    OCMVerify([app openURL:[OCMArg any] options:[OCMArg any] completionHandler:nil]);
}

@end
