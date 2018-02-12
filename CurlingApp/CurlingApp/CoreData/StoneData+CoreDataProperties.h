//
//  StoneData+CoreDataProperties.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "StoneData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StoneData (CoreDataProperties)

+ (NSFetchRequest<StoneData *> *)fetchRequest;

@property (nonatomic) int32_t endNumber;
@property (nonatomic) BOOL isStoneColorRed;
@property (nonatomic) int32_t stepNumber;
@property (nonatomic) float stonePositionX;
@property (nonatomic) float stonePositionY;
@property (nullable, nonatomic, copy) NSString *hashLink;

@end

NS_ASSUME_NONNULL_END
