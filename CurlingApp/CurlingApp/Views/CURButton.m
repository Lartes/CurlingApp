//
//  CURButton.m
//  CurlingApp
//
//  Created by Artem Lomov on 09/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURButton.h"

@implementation CURButton

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.layer.borderColor = [[UIColor colorWithWhite:0.7 alpha:0.5] CGColor];
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        self.layer.borderWidth = 1.;
        self.layer.cornerRadius = 5.;
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

@end