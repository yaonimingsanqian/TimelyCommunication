//
//  Conversation.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatViewCompent.h"
#import "TextMessage.h"
#import "MsgSaveHelper.h"

@interface Conversation : NSObject
{
    MsgSaveHelper *msgSaveHelper;
}

+ (Conversation*)sharedInstance;
- (void)sendMessage :(TextMessage*)message;
- (void)saveMsg :(BaseMesage*)message;
- (NSArray*)loadHistoryMsg :(NSString*)username;
- (void)pushAgreen :(NSString*)uname;
@end
