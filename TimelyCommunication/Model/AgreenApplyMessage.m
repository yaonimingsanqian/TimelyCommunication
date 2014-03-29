//
//  AgreenApplyMessage.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-8.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AgreenApplyMessage.h"
#import "Config.h"

@implementation AgreenApplyMessage

- (void)doSelfThing
{
    [super doSelfThing];
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewFriend,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:info];
}
@end
