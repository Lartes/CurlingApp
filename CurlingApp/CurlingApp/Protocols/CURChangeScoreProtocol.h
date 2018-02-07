//
//  CURChangeScoreProtocol.h
//  CurlingApp
//
//  Created by Artem Lomov on 05/02/2018.
//  Copyright © 2018 Artem Lomov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CURChangeScoreProtocol <NSObject>
@optional

- (BOOL)changeScoreForColor:(UIColor *)color byNumber:(NSInteger)number;

@end

