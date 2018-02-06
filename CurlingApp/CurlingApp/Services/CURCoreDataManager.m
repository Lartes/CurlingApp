//
//  CURCoreDataManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURCoreDataManager.h"
#import "AppDelegate.h"

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

- (NSArray *)loadAllGamesInfo
{
    NSArray* data = [self.coreDataContext executeFetchRequest:[GameInfo fetchRequest] error:nil];
    return data;
}

- (NSArray *)loadGamesInfoByHash:(NSString *)hashLink
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hashLink CONTAINS %@", hashLink];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [self.coreDataContext executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

- (void)saveGameInfo:(CURGameInfo *)gameInfoToSave
{
    GameInfo *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo" inManagedObjectContext:self.coreDataContext];
    gameInfo.teamNameFirst = gameInfoToSave.teamNameFirst;
    gameInfo.teamNameSecond = gameInfoToSave.teamNameSecond;
    gameInfo.hashLink = gameInfoToSave.hashLink;
    
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

@end
