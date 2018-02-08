//
//  GameInfo+CoreDataProperties.m
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "GameInfo+CoreDataProperties.h"

@implementation GameInfo (CoreDataProperties)

+ (NSFetchRequest<GameInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GameInfo"];
}

@dynamic data;
@dynamic teamNameFirst;
@dynamic teamNameSecond;
@dynamic hashLink;
@dynamic numberOfEnds;
@dynamic firstTeamScore;
@dynamic secondTeamScore;

@end
