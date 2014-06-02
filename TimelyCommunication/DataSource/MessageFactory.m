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
#import "ApplyMsg.h"
#import "RejectMsg.h"
#import "ReceiptMsg.h"
#import "EnterMsg.h"
@implementation MessageFactory

+ (BaseMesage*)createMsg:(XMPPMessage *)msg
{
    BaseMesage *baseMsg = nil;
    if([[msg type] isEqualToString:@"chat"])
        baseMsg = [[TextMessage alloc]init];
    if([[msg cmd]isEqualToString:@"agreen"])
        baseMsg = [[AgreenApplyMessage alloc]init];
    if([[msg cmd] isEqualToString:@"deleteContact"])
        baseMsg = [[DeleteContactMsg alloc]init];
    if([[msg cmd] isEqualToString:@"apply"])
        baseMsg = [[ApplyMsg alloc]init];
    if([[msg cmd] isEqualToString:@"reject"])
        baseMsg = [[RejectMsg alloc]init];
    if([[msg cmd] isEqualToString:@"received"])
        baseMsg = [[ReceiptMsg alloc]init];
    if([[msg cmd] isEqualToString:@"enter"])
        baseMsg = [[EnterMsg alloc]init];
        
    baseMsg.isIncoming = YES;
    baseMsg.from = [msg fromStr];
    baseMsg.to = [CommonData sharedCommonData].curentUser.username;
    baseMsg.type = [msg type];
    baseMsg.sendDate = [NSDate dateWithTimeIntervalSince1970:[[[msg attributeForName:@"time"] stringValue] doubleValue]];
    baseMsg.conversationId = [[baseMsg.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    baseMsg.msgContent = [msg body];
    baseMsg.messageId = [[msg attributeForName:@"id"] stringValue];
    return baseMsg;
}
@end
