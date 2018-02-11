//
//  GameInfo+CoreDataProperties.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//
//

#import "GameInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GameInfo (CoreDataProperties)

+ (NSFetchRequest<GameInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *teamNameFirst;
@property (nullable, nonatomic, copy) NSString *teamNameSecond;
@property (nullable, nonatomic, copy) NSString *hashLink;
@property (nonatomic) int32_t numberOfEnds;
@property (nonatomic) int32_t firstTeamScore;
@property (nonatomic) int32_t secondTeamScore;

@end

NS_ASSUME_NONNULL_END
