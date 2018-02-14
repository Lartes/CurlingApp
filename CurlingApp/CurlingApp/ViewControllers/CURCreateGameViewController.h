//
//  CURCreateGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURCoreDataManager.h"
#import "CURGameViewController.h"
#import "CURGameInfo.h"
#import "GameInfo+CoreDataClass.h"
#import "CURButton.h"
#import "Masonry.h"
#import "Constants.h"

@interface CURCreateGameViewController : UIViewController

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

@end
