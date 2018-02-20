//
//  CURGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURTouchDetectProtocol.h"
#import "CURGameManager.h"
#import "CURCloseGameViewController.h"
#import "CURScrollView.h"
#import "CURScoreView.h"
#import "CURButton.h"
#import "Masonry.h"
#import "Constants.h"

@interface CURGameViewController : UIViewController <CURTouchDetectProtocol>

/**
 Инициализирует объект с менеджером игры.
 @param gameManager Менеджер игры.
 */
- (instancetype)initWithManager:(CURGameManager *)gameManager;

@end
