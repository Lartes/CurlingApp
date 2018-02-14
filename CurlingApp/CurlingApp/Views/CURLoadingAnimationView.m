//
//  CURLoadingAnimationView.m
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import "CURLoadingAnimationView.h"

@interface CURLoadingAnimationView () <CAAnimationDelegate>

@property (nonatomic, strong) CABasicAnimation *basicAnimation;

@end

@implementation CURLoadingAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        self.layer.opacity = 0.3;
    }
    return self;
}

- (void)startAnimation
{
    self.basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.basicAnimation.repeatCount = 100;
    self.basicAnimation.duration = 1.;
    self.basicAnimation.autoreverses = YES;
    self.basicAnimation.toValue = @1;
    [self.layer addAnimation:self.basicAnimation forKey:@"basicanimkey"];
}

- (void)stopAnimation
{
    [self.layer removeAnimationForKey:@"basicanimkey"];
}

@end
