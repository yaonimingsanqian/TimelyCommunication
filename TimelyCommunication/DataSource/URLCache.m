//
//  URLCache.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-25.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "URLCache.h"

@implementation URLCache

SHARED_INSTANCE_GCD_USING_BLOCK(^{
    return [[self alloc]init];
})
- (id)init
{
    self = [super init];
    if(self)
    {
        cache = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)cacheURLStr :(NSString*)url name:(NSString*)uname type:(CacheType)type;
{
    NSString *typeStr = [NSString stringWithFormat:@"%d",type];
    NSMutableArray *info = [cache objectForKey:typeStr];
    if(!info)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:uname,@"username",url,@"avatar", nil]];
        [cache setObject:array forKey:typeStr];
    }else
    {
        for (NSMutableDictionary *person in info)
        {
            if([[person objectForKey:@"username"] isEqualToString:uname])
            {
                if([[person objectForKey:@"avatar"] isEqualToString:url])
                    return;
                [person setObject:url forKey:@"avatar"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"avatarchange" object:self userInfo:person];
            }
        }
        NSMutableDictionary *person = [NSMutableDictionary dictionaryWithObjectsAndKeys:uname,@"username",url,@"avatar", nil];
        [info addObject:person];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"avatarchange" object:self userInfo:person];
    }
}
- (NSString*)queryURLWithkey:(NSString *)key type:(CacheType)type
{
    NSArray *info = [cache objectForKey:[NSString stringWithFormat:@"%d",type]];
    for (NSDictionary *person in info)
    {
        if([[person objectForKey:@"username"] isEqualToString:key])
            return [person objectForKey:@"avatar"];
    }
    return nil;
}
@end
