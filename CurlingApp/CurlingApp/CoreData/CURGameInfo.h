//
//  CURGameInfo.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CURGameInfo : NSObject

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *teamNameFirst;
@property (nullable, nonatomic, copy) NSString *teamNameSecond;
@property (nullable, nonatomic, copy) NSString *hashLink;
@property (nonatomic) BOOL isFirstTeamColorRed;
@property (nonatomic) NSInteger numberOfEnds;
@property (nonatomic) NSInteger firstTeamScore;
@property (nonatomic) NSInteger secondTeamScore;

@end
