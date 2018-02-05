//
//  CUREndManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CUREndManager.h"

@interface CUREndManager ()

@property (nonatomic, strong) NSMutableArray<UIView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;
@property (nonatomic, assign) BOOL isEndFinishedBool;

@end

@implementation CUREndManager

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if(self)
    {
        _stonesArray = [NSMutableArray new];
        _isEndFinishedBool = NO;
        _stoneColor = color;
    }
    return self;
}

- (UIView *)addStone
{
    UIView *stone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    stone.layer.cornerRadius = 15;
    stone.backgroundColor = self.stoneColor;
    self.isEndFinishedBool = [self.output changeScoreForColor:self.stoneColor];
    [self changeColor];
    [self.stonesArray addObject:stone];
    return stone;
}

- (BOOL)isEndFinished
{
    return self.isEndFinishedBool;
}

- (void)changeColor
{
    if (self.stoneColor==[UIColor redColor])
    {
        self.stoneColor = [UIColor yellowColor];
    }
    else
    {
        self.stoneColor = [UIColor redColor];
    }
}

@end
