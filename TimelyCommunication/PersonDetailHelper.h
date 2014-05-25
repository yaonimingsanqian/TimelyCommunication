//
//  PersonDetailHelper.h
//  TimelyCommunication
//
//  Created by zhao on 14-5-25.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface PersonDetailHelper : NSObject

- (void)updatePersonDetail :(NSDictionary*)info :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccrss,NSError *error))complete;
- (void)queryPersonDetail :(NSArray*)usernames :(FMDatabaseQueue*)queue :(void(^)(NSArray *resultDic,NSError *error))complete;
- (void)deletePersonDetail :(NSArray*)usernames :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess,NSError *error))complete;
@end
