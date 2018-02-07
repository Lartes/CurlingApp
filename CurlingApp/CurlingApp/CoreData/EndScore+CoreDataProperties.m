//
//  EndScore+CoreDataProperties.m
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "EndScore+CoreDataProperties.h"

@implementation EndScore (CoreDataProperties)

+ (NSFetchRequest<EndScore *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EndScore"];
}

@dynamic endNumber;
@dynamic hashLink;
@dynamic score;

@end
