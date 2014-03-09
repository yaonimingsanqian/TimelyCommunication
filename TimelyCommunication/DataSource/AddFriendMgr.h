//
//  AddFriendMgr.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^AddSuccess)();
typedef void(^AddFailed)();

@interface AddFriendMgr : NSObject
+ (AddFriendMgr*)sharedInstance;
+ (void)destory;
- (void)addFriend :(NSString*)userName :(AddSuccess)success :(AddFailed)failed;
@end
