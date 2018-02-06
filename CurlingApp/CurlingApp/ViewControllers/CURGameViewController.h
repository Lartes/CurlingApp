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

@interface CURGameViewController : UIViewController <CURTouchDetectProtocol>

- (instancetype)initWithManager:(CURGameManager *)gameManager;

@end
