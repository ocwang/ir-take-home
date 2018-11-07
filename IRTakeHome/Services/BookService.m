//
//  BookService.m
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import "BookService.h"
#import "IRErrors.h"
#import "ErrorHelper.h"
#import "EBook.h"

@implementation BookService

+ (void)getEBooksForSearchQuery:(NSString *)query withHandler:(void (^_Nonnull)(NSArray *eBooks, NSError *error))handler {
    NSURL *eBookSearchURL = [self eBookSearchURLForQuery:query];
    
    // for more complex service layer, create network manager to manage shared
    // state between network requests
    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:eBookSearchURL
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSError *error = [ErrorHelper errorWithCode:kNetworkError];
                    handler(nil, error);
                    return;
                }
                
                NSError *jsonError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (jsonError) {
                    NSError *error = [ErrorHelper errorWithCode:kJSONDecodingError];
                    handler(nil, error);
                    return;
                }

                NSArray *eBookResultsJSON = jsonDict[@"results"];
                
                NSMutableArray *eBooks = [NSMutableArray arrayWithCapacity:[eBookResultsJSON count]];
                [eBookResultsJSON enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    EBook *eBook = [[EBook alloc] initWithJSON:obj];
                    if (eBook != nil) {
                        [eBooks addObject:eBook];
                    }
                }];
                
                handler(eBooks, nil);
            }] resume];
}

/*
 Private helper to generate NSURL for service; abstract into a router if more
 routes are added.
 */
+ (NSURL *)eBookSearchURLForQuery:(NSString *)query {
    // use NSURLComponents and NSURLQueryItem to construct NSURL with it's parameters
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:@"https://itunes.apple.com/search"];
    
    NSURLQueryItem *termQuery = [[NSURLQueryItem alloc] initWithName:@"term" value:query];
    NSURLQueryItem *mediaQuery = [[NSURLQueryItem alloc] initWithName:@"media" value:@"ebook"];
    NSURLQueryItem *entityQuery = [[NSURLQueryItem alloc] initWithName:@"entity" value:@"ebook"];
    NSURLQueryItem *limitQuery = [[NSURLQueryItem alloc] initWithName:@"limit" value:@"50"];
    
    components.queryItems = @[termQuery, mediaQuery, entityQuery, limitQuery];
    
    return components.URL;
}

@end
