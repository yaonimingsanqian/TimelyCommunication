//
//  ContactsMgr.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsMgr : NSObject
+ (ContactsMgr*)sharedInstance;
@property (nonatomic,strong) NSArray *friends;
- (void)parseFriends :(NSDictionary*)friends;
@end
