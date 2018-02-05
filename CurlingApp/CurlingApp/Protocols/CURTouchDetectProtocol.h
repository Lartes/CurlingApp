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

- (void)touchHappendAtCoord:(CGPoint)coord onView:(UIView *)view;

@end
