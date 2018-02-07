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

@interface CURShowGameViewController : UIViewController <CURTouchDetectProtocol>

- (instancetype)initWithManager:(CURShowGameManager *)gameManager;

@end