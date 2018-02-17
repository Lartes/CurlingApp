//
//  CURStoneData.h
//  CurlingApp
//
//  Created by Artem Lomov on 06/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CURStoneData : NSObject

@property (nonatomic) NSInteger endNumber;
@property (nonatomic) BOOL isStoneColorRed;
@property (nonatomic) NSInteger stepNumber;
@property (nonatomic) float stonePositionX;
@property (nonatomic) float stonePositionY;
@property (nullable, nonatomic, copy) NSString *hashLink;

@end
