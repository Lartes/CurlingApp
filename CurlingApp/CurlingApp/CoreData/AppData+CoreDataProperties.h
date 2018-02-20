//
//  AppData+CoreDataProperties.h
//  
//
//  Created by Artem Lomov on 13/02/2018.
//
//

#import "AppData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppData (CoreDataProperties)

+ (NSFetchRequest<AppData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accessToken;

@end

NS_ASSUME_NONNULL_END
