//
//  CURGameViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 04/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURTouchDetectProtocol.h"

@interface CURGameViewController : UIViewController <CURTouchDetectProtocol>

@property (nonatomic, strong) NSManagedObjectContext *coreDataContext;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, strong) UIColor *firstStoneColor;
@property (nonatomic, copy) NSString *hashLink;

@end
