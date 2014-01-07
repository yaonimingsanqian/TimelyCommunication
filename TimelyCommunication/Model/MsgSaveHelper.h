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
typedef void(^LoadMsgComplete)(NSArray* msgArray);
@interface MsgSaveHelper : NSObject
{
    //LoadMsgComplete loadHistoryMsgComplete;
}
- (BOOL)createDataBase :(NSString*)msgTableName;
- (BOOL)saveMsg :(BaseMesage*)msg;
- (NSArray*)loadHistoryMsg :(NSString*)conversationId;
@end
