//
//  CURNetworkManagerProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CURNetworkManagerProtocol <NSObject>

- (void)taskDidFinishedWithStatus:(BOOL)status;

@end
