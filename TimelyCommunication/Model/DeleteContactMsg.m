//
//  DeleteContactMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-29.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "DeleteContactMsg.h"
#import "Config.h"
@implementation DeleteContactMsg

- (void)doSelfThing
{
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kDeleteFriend,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:info];
}
@end
