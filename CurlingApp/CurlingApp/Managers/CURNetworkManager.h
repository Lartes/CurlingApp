//
//  CURNetworkManager.h
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CURCoreDataManager.h"
#import "CURNetworkManagerProtocol.h"
#import "Constants.h"

@interface CURNetworkManager : NSObject

@property (nonatomic, weak) id<CURNetworkManagerProtocol> output;
@property (nonatomic, strong) CURCoreDataManager *coreDataManager;

- (void)saveToDropbox;
- (void)loadFromDropbox;

@end
