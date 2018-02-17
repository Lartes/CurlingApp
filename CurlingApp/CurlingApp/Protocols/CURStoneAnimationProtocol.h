//
//  CURStoneAnimationProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 17/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CURStoneAnimationProtocol <NSObject>
@optional

/**
 Вызывается при завершении анимации камней.
 */
- (void)animationEnded;

@end
