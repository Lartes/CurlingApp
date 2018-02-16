//
//  CURLoadingAnimationView.h
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CURLoadingAnimationView : UIView

/**
 Запускает анимацию ожидания.
 */
- (void)startAnimation;

/**
 Останавливает анимацию ожидания.
 */
- (void)stopAnimation;

@end
