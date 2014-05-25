//
//  URLCache.h
//  TimelyCommunication
//
//  Created by zhao on 14-5-25.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedInstanceGCD.h"
typedef enum
{
    CacheTypePerson = 0
    
}CacheType;
@interface URLCache : NSObject
{
    @private
    NSMutableDictionary *cache;
    
}
+ (instancetype)sharedInstance;
- (void)destory;
- (void)cacheURLStr :(NSString*)url name:(NSString*)uname type:(CacheType)type;
- (NSString*)queryURLWithkey :(NSString*)key type:(CacheType)type;
- (void)removeCacheWithKey :(NSString*)key type:(CacheType)type;
@end
