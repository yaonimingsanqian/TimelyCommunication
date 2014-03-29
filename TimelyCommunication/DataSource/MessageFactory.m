//
//  MessageFactory.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "MessageFactory.h"
#import "CommonData.h"
#import "TextMessage.h"
#import "AgreenApplyMessage.h"
#import "DeleteContactMsg.h"
@implementation MessageFactory

+ (BaseMesage*)createMsg:(XMPPMessage *)msg
{
    BaseMesage *baseMsg = nil;
    if([[msg type] isEqualToString:@"chat"])
        baseMsg = [[TextMessage alloc]init];
    if([[msg type]isEqualToString:@"agreen"])
        baseMsg = [[AgreenApplyMessage alloc]init];
    if([[msg type] isEqualToString:@"deleteContact"])
        baseMsg = [[DeleteContactMsg alloc]init];
        
    baseMsg.isIncoming = YES;
    baseMsg.from = [msg fromStr];
    baseMsg.to = [CommonData sharedCommonData].curentUser.username;
    baseMsg.type = [msg type];
    baseMsg.sendDate = [NSDate dateWithTimeIntervalSince1970:[[[msg attributeForName:@"time"] stringValue] doubleValue]];
    baseMsg.conversationId = [[baseMsg.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    baseMsg.msgContent = [msg body];
    return baseMsg;
}
@end
