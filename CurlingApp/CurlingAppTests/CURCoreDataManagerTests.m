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

@interface CURCoreDataManager (CURTests)

@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@interface CURCoreDataManagerTests : XCTestCase

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end

@implementation CURCoreDataManagerTests

- (void)setUp {
    [super setUp];
    self.coreDataManager = OCMPartialMock([CURCoreDataManager new]);
}

- (void)tearDown {
    self.coreDataManager = nil;
    [super tearDown];
}

@end
