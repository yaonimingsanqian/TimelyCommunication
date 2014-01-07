//
//  BaseMesage.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    MessageText,
    MessageImage,
    MEssageAudion
}MessageType;
@interface BaseMesage : NSObject

@property (nonatomic,assign) BOOL isIncoming;
@property (nonatomic,copy) NSString *conversationId;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,copy) NSString *to;
@property (nonatomic,assign) MessageType type;
@property (nonatomic,copy) NSDate *sendDate;
@property (nonatomic,copy) NSString *msgContent;
@property (nonatomic,copy) NSString *messageId;
@end
