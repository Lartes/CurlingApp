//
//  CURTouchDetectProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CURTouchDetectProtocol <NSObject>
@optional

/**
 Вызывается при нажатии на экран.
 @param coord Координаты нажатия в системе координат view.
 @param view View по которому было нажатие.
 */
- (void)touchHappendAtCoord:(CGPoint)coord onView:(UIView *)view;

@end
