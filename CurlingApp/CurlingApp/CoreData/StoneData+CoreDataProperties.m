//
//  StoneData+CoreDataProperties.m
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "StoneData+CoreDataProperties.h"

@implementation StoneData (CoreDataProperties)

+ (NSFetchRequest<StoneData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"StoneData"];
}

@dynamic endNumber;
@dynamic isStoneColorRed;
@dynamic stepNumber;
@dynamic stonePositionX;
@dynamic stonePositionY;
@dynamic hashLink;

@end
