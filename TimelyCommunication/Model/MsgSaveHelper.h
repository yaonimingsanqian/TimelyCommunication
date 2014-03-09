//
//  MsgSaveHelper.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BaseMesage.h"
#import "TextMessage.h"
#import "BaseHelper.h"
typedef void(^LoadMsgComplete)(NSArray* msgArray);
@interface MsgSaveHelper : BaseHelper
- (BOOL)saveMsg :(BaseMesage*)msg;
- (NSArray*)loadHistoryMsg :(NSString*)conversationId;
- (void)loadHistoryMsg :(NSString*)conversationId :(LoadMsgComplete)complete;
- (TextMessage*)queryLastMsg :(NSString*)username :(NSString*)conId;
@end
