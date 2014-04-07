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
+ (void)destory;
@property (nonatomic,strong) NSMutableArray *conversations;
- (BOOL)isConversationExist :(NSString*)con;
- (BOOL)removeConversations :(NSString*)con;
@end
