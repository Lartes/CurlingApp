//
//  CURSettingsViewController.h
//  CurlingApp
//
//  Created by Artem Lomov on 12/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURCoreDataManager.h"
#import "CURNetworkManager.h"
#import "CURNetworkManagerProtocol.h"

@interface CURSettingsViewController : UIViewController <CURNetworkManagerProtocol>

@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

- (void)setReceivedURL:(NSURL *)url;

@end
