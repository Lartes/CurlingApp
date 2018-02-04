//
//  CUREndManager.m
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CUREndManager.h"

@interface CUREndManager ()

@property (nonatomic, strong) NSArray<UIView *> *stonesArray;
@property (nonatomic, strong) UIColor *stoneColor;

@end

@implementation CUREndManager

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if(self)
    {
        _stoneColor = color;
    }
    return self;
}

- (UIView *)addStone
{
    UIView *stone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    stone.layer.cornerRadius = 15;
    stone.backgroundColor = self.stoneColor;
    [self.output changeScoreForColor:self.stoneColor];
    [self changeColor];
    self.stonesArray = [NSArray arrayWithObject:stone];
    return stone;
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
