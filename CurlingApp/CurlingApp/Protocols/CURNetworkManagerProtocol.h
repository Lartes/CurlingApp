//
//  CURNetworkManagerProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 14/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CURNetworkManagerProtocol <NSObject>
@optional

/**
 Вызывается для сохранения полученного URL в базе данных.
 @param url URL для сохранения.
 */
- (void)saveReceivedURL:(NSURL *)url;

/**
 Вызывается при окончании задачи загрузки.
 @param status YES, если задача завершилась успешно.
 */
- (void)taskDidFinishedWithStatus:(BOOL)status;

@end
