//
//  BookService.h
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookService : NSObject

+ (void)getEBooksForSearchQuery:(NSString *)query withHandler:(void (^_Nonnull)(NSArray *eBooks, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
