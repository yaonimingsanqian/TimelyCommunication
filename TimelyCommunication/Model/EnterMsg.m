//
//  EnterMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-29.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "EnterMsg.h"
#import "Config.h"

@implementation EnterMsg

- (void)doSelfThing
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBuddyTyping object:nil userInfo:nil];
}
@end
