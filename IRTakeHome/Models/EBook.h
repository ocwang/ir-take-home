//
//  EBook.h
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EBook : NSObject

@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSString *authors;
@property (strong, nonatomic) NSString *bookSummary;
@property (strong, nonatomic) NSString *imageURLSmall;
@property (strong, nonatomic) NSString *imageURLLarge;
@property (strong, nonatomic) NSString *iTunesStoreURL;

- (id)initWithJSON:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
