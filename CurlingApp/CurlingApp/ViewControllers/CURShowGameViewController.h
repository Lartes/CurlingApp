//
//  CURShowGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 07/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURTouchDetectProtocol.h"
#import "CURShowGameManager.h"
#import "CURCloseGameViewController.h"
#import "CURScrollView.h"
#import "CURScoreView.h"
#import "CURButton.h"
#import "Masonry.h"
#import "Constants.h"

@interface CURShowGameViewController : UIViewController <CURTouchDetectProtocol>

/**
 Инициализирует объект с менеджером просмотра игры.
 @param gameManager Менеджер просмотра игры.
 */
- (instancetype)initWithManager:(CURShowGameManager *)gameManager;

@end
