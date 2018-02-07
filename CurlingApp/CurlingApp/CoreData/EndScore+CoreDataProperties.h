//
//  EndScore+CoreDataProperties.h
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "EndScore+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EndScore (CoreDataProperties)

+ (NSFetchRequest<EndScore *> *)fetchRequest;

@property (nonatomic) int32_t endNumber;
@property (nullable, nonatomic, copy) NSString *hashLink;
@property (nullable, nonatomic, copy) NSString *score;

@end

NS_ASSUME_NONNULL_END
