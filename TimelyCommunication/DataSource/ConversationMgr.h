//
//  ConversationMgr.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationMgr : NSObject

+ (ConversationMgr*)sharedInstance;
@property (nonatomic,strong) NSMutableArray *conversations;
- (void)saveConversation :(NSString*)con;
- (BOOL)isConversationExist :(NSString*)con;
- (void)queryConversation;
- (void)updateConversation :(NSString*)conversationName :(BOOL)isAdd;
- (int)queryNotReadCount :(NSString*)conversationName;
@end
