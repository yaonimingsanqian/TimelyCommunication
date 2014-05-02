//
//  ReceiptMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-5-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ReceiptMsg.h"
#import "DataStorage.h"
#import "Config.h"

@implementation ReceiptMsg

- (void)doSelfThing
{
    
    [[DataStorage sharedInstance] markedAsSendSuccess:self.messageId :^(BOOL isSuccess) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSendMsgSuccess object:self.messageId userInfo:nil];
    }];
}
@end
