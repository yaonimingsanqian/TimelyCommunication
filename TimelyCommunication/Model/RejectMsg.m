//
//  RejectMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-4-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RejectMsg.h"
#import "ConversationMgr.h"
#import "Config.h"
#import "DataStorage.h"
#import "GTMBase64.h"
@implementation RejectMsg

- (void)doSelfThing
{
    self.msgContent = [GTMBase64 decodeBase64String:self.msgContent];
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewTextMsg,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[DataStorage sharedInstance] saveMsg:self :^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewTextMsg object:info];
    }];
    
}
@end
