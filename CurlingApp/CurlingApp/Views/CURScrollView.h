//
//  CURScrollView.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURTouchDetectProtocol.h"

@interface CURScrollView : UIScrollView

@property (nonatomic, weak) id<CURTouchDetectProtocol> output;

@end
