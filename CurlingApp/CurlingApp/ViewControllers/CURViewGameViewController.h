//
//  CURViewGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo+CoreDataClass.h"
#import "CURCoreDataManager.h"
#import "CURShowGameManager.h"
#import "CURShowGameViewController.h"
#import "CURScoreTableViewCell.h"
#import "Masonry.h"
#import "Constants.h"

@interface CURViewGameViewController : UIViewController

@property (nonatomic, strong) GameInfo *gameInfo;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end
