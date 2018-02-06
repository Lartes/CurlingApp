//
//  SURCloseGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CURCloseGameViewController : UIViewController

@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, copy) NSString *hashLink;
@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;

@end
