//
//  CURCoreDataManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCoreDataManager.h"

@interface CURCoreDataManager ()

@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@implementation CURCoreDataManager


#pragma mark - Lifecycle

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CurlingApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.coreDataContext = self.persistentContainer.viewContext;
    }
    return self;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSError *error = nil;
    if ([self.coreDataContext hasChanges] && ![self.coreDataContext save:&error]) {
        abort();
    }
}


#pragma mark - Load Actions

- (NSArray<GameInfo *> *)loadAllGamesInfo
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return data;
}

- (NSArray<StoneData *> *)loadAllStoneData
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"StoneData"] error:nil];
    return data;
}

- (NSArray<EndScore *> *)loadAllEndScore
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"EndScore"] error:nil];
    return data;
}

- (AppData *)loadAppData
{
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"AppData"] error:nil];
    return fetchedObjects.firstObject;
}

- (GameInfo *)loadGamesInfoByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects.firstObject;
}

- (NSArray<StoneData *> *)loadStonesDataByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (NSArray<StoneData *> *)loadStonesDataByHash:(NSString *)hashLink endNumber:(NSInteger)endNumber
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@ AND endNumber == %@", hashLink, @(endNumber)];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stepNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (NSArray<EndScore *> *)loadEndScoreByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}


#pragma mark - Save Actions

- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo"
                                                       inManagedObjectContext:self.coreDataContext];
    gameInfo.teamNameFirst = gameInfoToSave.teamNameFirst;
    gameInfo.teamNameSecond = gameInfoToSave.teamNameSecond;
    gameInfo.hashLink = gameInfoToSave.hashLink;
    gameInfo.date = gameInfoToSave.date;
    gameInfo.isFirstTeamColorRed = gameInfoToSave.isFirstTeamColorRed;
    gameInfo.numberOfEnds = (int)gameInfoToSave.numberOfEnds;
    gameInfo.firstTeamScore = (int)gameInfoToSave.firstTeamScore;
    gameInfo.secondTeamScore = (int)gameInfoToSave.secondTeamScore;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [gameInfo.managedObjectContext save:nil];
    });
}

- (void)saveStoneData:(CURStoneData *)stoneDataToSave
{
    StoneData *stoneData = [NSEntityDescription insertNewObjectForEntityForName:@"StoneData"
                                                         inManagedObjectContext:self.coreDataContext];
    stoneData.endNumber = (int)stoneDataToSave.endNumber;
    stoneData.stepNumber = (int)stoneDataToSave.stepNumber;
    stoneData.isStoneColorRed = stoneDataToSave.isStoneColorRed;
    stoneData.stonePositionX = stoneDataToSave.stonePositionX;
    stoneData.stonePositionY = stoneDataToSave.stonePositionY;
    stoneData.hashLink = stoneDataToSave.hashLink;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [stoneData.managedObjectContext save:nil];
    });
}

- (void)saveNumberOfEnds:(NSInteger)number forHash:(NSString *)hashLink
{
    GameInfo *gameInfo = [self loadGamesInfoByHash:hashLink];
    gameInfo.numberOfEnds = (int)number;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [gameInfo.managedObjectContext save:nil];
    });
}

- (void)saveFirstScore:(NSInteger)firstScore secondScore:(NSInteger)secondScore forHash:(NSString *)hashLink
{
    GameInfo *gameInfo = [self loadGamesInfoByHash:hashLink];
    gameInfo.firstTeamScore = (int)firstScore;
    gameInfo.secondTeamScore = (int)secondScore;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [gameInfo.managedObjectContext save:nil];
    });
}

- (void)saveFirstScore:(NSInteger)firstScore secondScore:(NSInteger)secondScore forEnd:(NSInteger)endNumber hash:(NSString *)hashLink
{
    EndScore *endScore = [NSEntityDescription insertNewObjectForEntityForName:@"EndScore"
                                                       inManagedObjectContext:self.coreDataContext];
    endScore.hashLink = hashLink;
    endScore.firstTeamScore = (int)firstScore;
    endScore.secondTeamScore = (int)secondScore;
    endScore.endNumber = (int)endNumber;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [endScore.managedObjectContext save:nil];
    });
}

- (BOOL)saveAccessToken:(NSString *)accessToken
{
    if(accessToken.length == 0)
    {
        return NO;
    }
    
    AppData *appData = [self loadAppData];
    if(!appData)
    {
        appData = [NSEntityDescription insertNewObjectForEntityForName:@"AppData"
                                                inManagedObjectContext:self.coreDataContext];
    }
    appData.accessToken = accessToken;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appData.managedObjectContext save:nil];
    });
    
    return YES;
}


#pragma mark - Delete Actions

- (void)deleteGameByHash:(NSString *)hashLink
{
    GameInfo *gameInfo = [self loadGamesInfoByHash:hashLink];
    
    NSArray *stonesToDelete = [self loadStonesDataByHash:hashLink];
    for (StoneData *stoneData in stonesToDelete)
    {
        [self.coreDataContext deleteObject:stoneData];
    }
    
    NSArray *endScoresToDelete = [self loadEndScoreByHash:hashLink];
    for (EndScore *endScore in endScoresToDelete)
    {
        [self.coreDataContext deleteObject:endScore];
    }
    
    [self.coreDataContext deleteObject:gameInfo];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coreDataContext save:nil];
    });
}

- (void)deleteEndByHash:(NSString *)hashLink endNumber:(NSInteger)endNumber
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@ AND endNumber == %@", hashLink, @(endNumber)];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    for (StoneData *stoneData in fetchedObjects)
    {
        [self.coreDataContext deleteObject:stoneData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coreDataContext save:nil];
    });
}

- (void)clearCoreData
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"GameInfo"] error:nil];
    for (GameInfo *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    data = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"StoneData"] error:nil];
    for (StoneData *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    data = [self.coreDataContext executeFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"EndScore"] error:nil];
    for (EndScore *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coreDataContext save:nil];
    });
}

@end
