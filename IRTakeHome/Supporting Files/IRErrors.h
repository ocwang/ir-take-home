//
//  IRErrors.h
//  IRTakeHome
//
//  Created by Chase Wang on 11/6/18.
//  Copyright © 2018 ocw. All rights reserved.
//

#ifndef IRErrors_h
#define IRErrors_h

typedef NS_ENUM(NSInteger, IRError) {
    kNetworkError,
    kJSONDecodingError,
    kInvalidJSONError,
    kUnknownError
};

#endif /* IRErrors_h */
