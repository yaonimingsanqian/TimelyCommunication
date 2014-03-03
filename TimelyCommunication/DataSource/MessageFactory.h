//
//  MessageFactory.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMesage.h"
#import "XMPPMessage.h"

@interface MessageFactory : NSObject

+ (BaseMesage*)createMsg :(XMPPMessage*)msg;
@end
