//
//  CommonData.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "CommonData.h"
static CommonData *sharedInstance = nil;
@implementation CommonData

+(CommonData*)sharedCommonData
{
    if(!sharedInstance)
    {
        sharedInstance = [[CommonData alloc]init];
        sharedInstance.curentUser = [[User alloc]init];
    }
    
    return sharedInstance;
}
@end
