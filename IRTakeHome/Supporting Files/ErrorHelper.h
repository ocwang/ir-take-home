//
//  ErrorHelper.h
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRErrors.h"

NS_ASSUME_NONNULL_BEGIN

@interface ErrorHelper : NSObject

+ (NSError *)errorWithCode:(IRError)code;

@end

NS_ASSUME_NONNULL_END
