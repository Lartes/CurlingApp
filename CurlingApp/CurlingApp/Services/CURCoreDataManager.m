//
//  CURCoreDataManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCoreDataManager.h"

@interface CURCoreDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end

@implementation CURCoreDataManager

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        NSPersistentContainer *container = ((AppDelegate *) (application.delegate)).persistentContainer;
        NSManagedObjectContext *context = container.viewContext;
        _coreDataContext = context;
    }
    return self;
}

- (void)clearCoreData
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[GameInfo fetchRequest] error:nil];
    for (StoneData *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    data = [self.coreDataContext executeFetchRequest:[StoneData fetchRequest] error:nil];
    for (StoneData *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    data = [self.coreDataContext executeFetchRequest:[EndScore fetchRequest] error:nil];
    for (StoneData *item in data)
    {
        [self.coreDataContext deleteObject:item];
    }
    [self.coreDataContext save:nil];
}

- (NSArray *)loadAllGamesInfo
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *data = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return data;
}

- (NSArray *)loadAllStoneData
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[StoneData fetchRequest] error:nil];
    return data;
}

- (NSArray *)loadAllEndScore
{
    NSArray *data = [self.coreDataContext executeFetchRequest:[EndScore fetchRequest] error:nil];
    return data;
}

- (AppData *)loadAppData
{
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:[AppData fetchRequest] error:nil];
    if (fetchedObjects.count > 0)
    {
        return fetchedObjects[0];
    }
    return nil;
}

- (GameInfo *)loadGamesInfoByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    if (fetchedObjects.count > 0)
    {
        return fetchedObjects[0];
    }
    return nil;
}

- (NSArray *)loadStonesDataByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (NSArray *)loadStonesDataByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@ AND endNumber == %@", hashLink, @(endNumber)];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stepNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (NSArray *)loadEndScoreByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo" inManagedObjectContext:self.coreDataContext];
    gameInfo.teamNameFirst = gameInfoToSave.teamNameFirst;
    gameInfo.teamNameSecond = gameInfoToSave.teamNameSecond;
    gameInfo.hashLink = gameInfoToSave.hashLink;
    gameInfo.date = gameInfoToSave.date;
    gameInfo.isFirstTeamColorRed = gameInfoToSave.isFirstTeamColorRed;
    gameInfo.numberOfEnds = gameInfoToSave.numberOfEnds;
    gameInfo.firstTeamScore = gameInfoToSave.firstTeamScore;
    gameInfo.secondTeamScore = gameInfoToSave.secondTeamScore;
    
    NSError *error = nil;
    if (![gameInfo.managedObjectContext save:&error])
    {
        NSLog(@"Object wasn't saved");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)saveStoneData:(CURStoneData *)stoneDataToSave
{
    StoneData *stoneData = [NSEntityDescription insertNewObjectForEntityForName:@"StoneData" inManagedObjectContext:self.coreDataContext];
    stoneData.endNumber = stoneDataToSave.endNumber;
    stoneData.stepNumber = stoneDataToSave.stepNumber;
    stoneData.isStoneColorRed = stoneDataToSave.isStoneColorRed;
    stoneData.stonePositionX = stoneDataToSave.stonePositionX;
    stoneData.stonePositionY = stoneDataToSave.stonePositionY;
    stoneData.hashLink = stoneDataToSave.hashLink;
    
    NSError *error = nil;
    if (![stoneData.managedObjectContext save:&error])
    {
        NSLog(@"Object wasn't saved");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)saveNumberOfEnds:(NSInteger)number forHash:(NSString *)hashLink
{
    GameInfo *gameInfo = [self loadGamesInfoByHash:hashLink];
    gameInfo.numberOfEnds = number;
    
    NSError *error = nil;
    if (![gameInfo.managedObjectContext save:&error])
    {
        NSLog(@"Object wasn't saved");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)saveFirstScore:(NSInteger)firstScore andSecondScore:(NSInteger)secondScore forHash:(NSString *)hashLink
{
    GameInfo *gameInfo = [self loadGamesInfoByHash:hashLink];
    gameInfo.firstTeamScore = firstScore;
    gameInfo.secondTeamScore = secondScore;
    
    NSError *error = nil;
    if (![gameInfo.managedObjectContext save:&error])
    {
        NSLog(@"Object wasn't saved");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (void)saveFirstScore:(NSInteger)firstScore andSecondScore:(NSInteger)secondScore forEnd:(NSInteger)endNumber andHash:(NSString *)hashLink
{
    EndScore *endScore = [NSEntityDescription insertNewObjectForEntityForName:@"EndScore" inManagedObjectContext:self.coreDataContext];
    endScore.hashLink = hashLink;
    endScore.firstTeamScore = firstScore;
    endScore.secondTeamScore = secondScore;
    endScore.endNumber = endNumber;
    
    NSError *error = nil;
    if (![endScore.managedObjectContext save:&error])
    {
        NSLog(@"Object wasn't saved");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

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
    [self.coreDataContext save:nil];
}

- (void)deleteEndByHash:(NSString *)hashLink andEndNumber:(NSInteger)endNumber
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@ AND endNumber == %@", hashLink, @(endNumber)];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stepNumber" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    
    for (StoneData *stoneData in fetchedObjects)
    {
        [self.coreDataContext deleteObject:stoneData];
    }
    [self.coreDataContext save:nil];
}

- (BOOL)saveAccessToken:(NSString *)accessToken
{
    if(accessToken.length>0)
    {
        AppData *appData = [self loadAppData];
        if(!appData)
        {
            appData = [NSEntityDescription insertNewObjectForEntityForName:@"AppData" inManagedObjectContext:self.coreDataContext];
        }
        appData.accessToken = accessToken;
        
        NSError *error = nil;
        if (![appData.managedObjectContext save:&error])
        {
            NSLog(@"Object wasn't saved");
            NSLog(@"%@, %@", error, error.localizedDescription);
            return NO;
        }
        
        return YES;
    }
    return NO;
}

@end
