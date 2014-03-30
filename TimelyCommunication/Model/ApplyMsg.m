//
//  ApplyMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-30.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ApplyMsg.h"
#import "Config.h"

@implementation ApplyMsg

- (void)doSelfThing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewFriendApply object:nil];
}
@end
