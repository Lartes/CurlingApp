//
//  AppData+CoreDataProperties.m
//  
//
//  Created by Artem Lomov on 13/02/2018.
//
//

#import "AppData+CoreDataProperties.h"

@implementation AppData (CoreDataProperties)

+ (NSFetchRequest<AppData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AppData"];
}

@dynamic accessToken;

@end
