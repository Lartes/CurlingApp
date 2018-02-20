//
//  CURGamesTableViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURGameTableViewCell.h"
#import "CURCreateGameViewController.h"
#import "CURViewGameViewController.h"
#import "CURCoreDataManager.h"
#import "GameInfo+CoreDataClass.h"
#import "CURSettingsViewController.h"
#import "Masonry.h"

@interface CURGamesTableViewController : UIViewController

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end
