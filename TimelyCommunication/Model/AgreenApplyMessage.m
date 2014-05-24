//
//  AgreenApplyMessage.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-8.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AgreenApplyMessage.h"
#import "Config.h"
#import "ConversationMgr.h"
#import "DataStorage.h"
#import "GTMBase64.h"
#import <Parse/Parse.h>
#import "CommonData.h"
@implementation AgreenApplyMessage

- (void)doSelfThing
{
    self.msgContent = [GTMBase64 decodeBase64String:self.msgContent];
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewTextMsg,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewTextMsg object:info];
    BOOL isExcute = [[ConversationMgr sharedInstance] isConversationExist:fromwhere];
    if(!isExcute)
    {
        [[ConversationMgr sharedInstance].conversations addObject:self.conversationId];
    }
    [[DataStorage sharedInstance] saveMsg:self :nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:info];

    
}
- (BOOL)isFriendExist :(NSString*)friend :(NSArray*)friends
{
    for (NSString *unmae in friends)
    {
        if([unmae isEqualToString:friend])
        {
            return YES;
        }
    }
    return NO;
}
@end
