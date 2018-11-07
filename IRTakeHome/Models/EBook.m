//
//  EBook.m
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import "EBook.h"

@implementation EBook

/*
 Custom failable initializer returns nil if JSON doesn't contain expected data
 or has invalid format
 */
- (id)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        if (!json) {
            return nil;
        }
        
        NSString *bookTitle = json[@"trackName"];
        if (!bookTitle) {
            return nil;
        }
        
        self.bookTitle = bookTitle;
        
        NSString *authors = json[@"artistName"];
        if (!authors) {
            return nil;
        }
        
        self.authors = authors;
        
        NSString *bookSummary = json[@"description"];
        if (!bookSummary) {
            return nil;
        }
        
        self.bookSummary = bookSummary;
        
        NSString *imageURLSmall = json[@"artworkUrl60"];
        if (!imageURLSmall) {
            return nil;
        }
        
        self.imageURLSmall = imageURLSmall;
        
        NSString *imageURLLarge = json[@"artworkUrl100"];
        if (!imageURLLarge) {
            return nil;
        }
        
        self.imageURLLarge = imageURLLarge;
        
        NSString *iTunesStoreURL = json[@"trackViewUrl"];
        if (!iTunesStoreURL) {
            return nil;
        }
        
        self.iTunesStoreURL = iTunesStoreURL;
    }
    
    return self;
}

@end
