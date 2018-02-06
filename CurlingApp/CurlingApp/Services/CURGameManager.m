//
//  CURGameManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURGameManager.h"
#import "StoneData+CoreDataClass.h"

@interface CURGameManager ()

@property (nonatomic, strong) NSMutableArray<UIView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) BOOL isEndFinishedBool;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, copy) NSString *hashLink;

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
        _endNumber = 0;
        _stepNumber = 1;
        _hashLink = hashLink;
    }
    return self;
}

- (UIView *)addStone
{
    [self saveToCoreData];
    self.stepNumber += 1;
    
    UIView *stone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    stone.layer.cornerRadius = 15;
    stone.backgroundColor = self.stoneColor;
    self.isEndFinishedBool = [self.output changeScoreForColor:self.stoneColor];
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

#pragma mark - CoreData

- (void)saveToCoreData
{
    StoneData *stoneData = nil;
    for (UIView *stone in self.stonesArray)
    {
        stoneData = [NSEntityDescription insertNewObjectForEntityForName:@"StoneData" inManagedObjectContext:self.coreDataContext];
        stoneData.endNumber = self.endNumber;
        stoneData.stepNumber = self.stepNumber;
        stoneData.isStoneColorRed = [stone backgroundColor] == [UIColor redColor];
        stoneData.stonePositionX = [stone center].x;
        stoneData.stonePositionY = [stone center].y;
        stoneData.hashLink = self.hashLink;
        
        NSError *error = nil;
        if (![stoneData.managedObjectContext save:&error])
        {
            NSLog(@"Object wasn't saved");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

@end