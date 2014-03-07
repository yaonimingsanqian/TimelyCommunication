//
//  AddFriendMgr.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFriendMgr : NSObject
+ (AddFriendMgr*)sharedInstance;
- (void)addFriend :(NSString*)userName;
@end
