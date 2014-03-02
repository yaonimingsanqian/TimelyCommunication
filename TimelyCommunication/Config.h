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
#define kChatViewFrame CGRectMake(0, 0, 320, 520)
#define kInputViewFrame CGRectMake(0, 520, 320, 48)
#define kInputViewColor [UIColor colorWithRed:211/255.f green:211/255.f blue:211/255.f alpha:1.f];
#define kSoundAndTextBtnFrame CGRectMake(5, 14, 20, 20)
#define kInputTextFrame CGRectMake(35, 10, 220, 28)
#define kFaceBtnFrame CGRectMake(260, 12, 24, 24)
#define kMoreBtnFrame CGRectMake(295, 15, 18, 18)
#define kSoundAndTextBtnBgImage @"sound.png"
#define kFaceBtnBgImage @"face.png"
#define kMoreBtnBgImage @"more.png"

#pragma mark - 数据库操作
#define DATABASE_PATH(useraccount) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingFormat:@"/%@weChat.sqlite",useraccount]
#define kMsgTableName @"msgTable"

#pragma mark - 用户信息
#define kXMPPmyJID @"kXMPPmyJID"
#define kXMPPmyPassword @"kXMPPmyPassword"

#pragma mark - 服务器信心
#define kServerName @"127.0.0.1"

#pragma mark - 通知名字
#define kRegisterSuccess @"kRegisterSuccess"
#define kRegisterFailed @"kRegisterFailed"

#endif
