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

+ (Conversation*)sharedInstance;
+ (void)destory;
- (void)sendMessage :(TextMessage*)message;
- (void)pushAgreen :(NSString*)uname;
- (void)pushDeleteContact :(NSString*)uname;
- (void)pushApply :(NSString*)uname;
@end
