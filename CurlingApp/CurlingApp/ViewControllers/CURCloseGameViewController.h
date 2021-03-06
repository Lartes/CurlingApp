//
//  SURCloseGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURGameManager.h"
#import "CURViewGameViewController.h"
#import "CURGameViewController.h"
#import "CURCoreDataManager.h"
#import "GameInfo+CoreDataClass.h"
#import "CURButton.h"
#import "Masonry.h"
#import "Constants.h"

@interface CURCloseGameViewController : UIViewController

@property (nonatomic, strong) CURGameManager *gameManager;

@end
