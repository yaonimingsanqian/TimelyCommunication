//
//  Config.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#ifndef HLPChatVoewDemo_Config_h
#define HLPChatVoewDemo_Config_h

#pragma - mark -会话页面的宏定义

#define kInputMaxHeight 88
#define kInpuTextFrameOriginYOffset 7
#define kChatViewFrame CGRectMake(0, 0, 320, 568-48)//520
#define kChatViewFrameForIPHONE4 CGRectMake(0, 0, 320, 480-48)
#define kInputViewFrame CGRectMake(0, 568-48, 320, 48)
#define kInputViewFrameForIPHONE4 CGRectMake(0, 480-48, 320, 48)//432
#define kInputViewColor [UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1.f];
#define kSoundAndTextBtnFrame CGRectMake(5, 14, 20, 20)
#define kInputTextFrame CGRectMake(35, kInpuTextFrameOriginYOffset, 220, 34)
#define kFaceBtnFrame CGRectMake(260, 12, 24, 24)
#define kMoreBtnFrame CGRectMake(295, 15, 18, 18)
#define kSoundAndTextBtnBgImage @"sound.png"
#define kFaceBtnBgImage @"face.png"
#define kMoreBtnBgImage @"more.png"

//通讯录刷新通知所需
#define kNewTextMsg @"kNewTextMsg"
#define kNewFriend @"kNewFriend"
#define kDeleteFriend @"kDeleteFriend"
#define kMsgFrom @"kMsgFrom"
#define kRefreshtype @"kRefreshtype"
#define kChatMoreBtnClick @"kChatMoreBtnClick"

#pragma mark - 数据库操作
#define DATABASE_PATH(useraccount) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingFormat:@"/%@.sqlite",useraccount]
#define kMsgTableName @"msgTable"
#define kConversationName @"conversations"
#define kRedPointName @"redpoint"
#define kContactName @"contact"

#pragma mark - 用户信息
#define kXMPPmyJID @"kXMPPmyJID"
#define kXMPPmyPassword @"kXMPPmyPassword"

#pragma mark - 服务器信心
#define kServerName @"127.0.0.1"

#pragma mark - 通知名字
#define kRegisterSuccess @"kRegisterSuccess"
#define kRegisterFailed @"kRegisterFailed"
#define kRefeshcontact @"kRefeshcontact"
#define kContactLoadFinish @"kContactLoadFinish"
#define kDatabaseCreateFinished @"kDatabaseCreateFinished"
#define kNewFriendApply @"kNewFriendApply"
#define kFriendAddFinished @"kFriendAddFinished"
#define kFriendAddFailed @"kFriendAddFailed"
#define kSaveContact @"kSaveContact" //保存了一个联系人
#define kDeleteContact @"kDeleteContact"//删除一个联系人
#define kContactDidLoad @"kContactDidLoad"
#define kLoginSuccess @"kLoginSuccess"
#define kLoginFailed @"kLoginFailed"
#define kSendMsgSuccess @"kSendMsgSuccess"
//表字段以及类型
//会话表
#define kConversationColumns @[@"conversationName",@"type",@"notReadCount"]
#define kConversationColumnsType @[@"VARCHAR",@"VARCHAR",@"int"]

//消息表
#define kMsgColumns @[@"type",@"from",@"to",@"msgContent",@"sendDate",@"conversationId",@"isIncoming",@"msgId",@"isSendSuccess"]
#define kMsgFieldType @[@"int",@"VARCHAR",@"VARCHAR",@"VARCHAR",@"DATETIME",@"VARCHAR",@"int"]

//红点表
#define kRedPointColumns @[@"type",@"count"]
#define kRedPointColumnsType @[@"VARCHAR",@"int"]

//通讯录表
#define kContactColumns @[@"uid",@"type"]
#define kContactColumnsType @[@"VARCHAR",@"int"]


//红点view的tag
#define kRedPointTag 13

//红点提示类型
#define kNewFriend @"kNewFriend"

//数据库版本
#define kDBVersion @"2"



#endif
