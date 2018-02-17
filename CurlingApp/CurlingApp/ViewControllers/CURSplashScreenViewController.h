//
//  CURSplashScreenViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 11/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURGamesTableViewController.h"
#import "CURStoneAnimationController.h"
#import "CURStoneAnimationProtocol.h"
#import "CURCoreDataManager.h"

@interface CURSplashScreenViewController : UIViewController <CURStoneAnimationProtocol>

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end
