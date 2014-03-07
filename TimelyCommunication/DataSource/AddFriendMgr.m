//
//  AddFriendMgr.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AddFriendMgr.h"
#import "SMClient.h"
static AddFriendMgr *shared = nil;
@implementation AddFriendMgr
+ (AddFriendMgr*)sharedInstance
{
    if(!shared)
        shared = [[AddFriendMgr alloc]init];
    return shared;
}
- (void)addFriend:(NSString *)userName
{
    
}
@end
