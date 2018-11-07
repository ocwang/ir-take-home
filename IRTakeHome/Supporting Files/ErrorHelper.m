//
//  ErrorHelper.m
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#import "ErrorHelper.h"

@implementation ErrorHelper

+ (NSError *)errorWithCode:(IRError)code {
    NSDictionary *userInfo = [ErrorHelper userInfoForCode:code];
    
    return [NSError errorWithDomain:@"com.ocwang.IRTakeHome"
                               code:code
                           userInfo:userInfo];
}

+ (NSDictionary *)userInfoForCode:(IRError)code {
    switch (code) {
        case kNetworkError:
            return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Network request unsuccessful, please try again.", nil)};
            
        case kJSONDecodingError:
            return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Error decoding JSON from HTTP response.", nil)};
            
        case kInvalidJSONError:
            return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid JSON data, please check API.", nil)};
            
        case kUnknownError:
            return @{NSLocalizedDescriptionKey: NSLocalizedString(@"Unknown error occurred, please try again.", nil)};
    }
}

@end
