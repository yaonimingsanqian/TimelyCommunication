//
//  CommonData.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CommonData : NSObject
@property (nonatomic,strong) User *curentUser;
+ (CommonData*)sharedCommonData;
@end
