//
//  ContactsHelper.h
//  TimelyCommunication
//
//  Created by zhao on 14-4-19.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"


@interface ContactsHelper : NSObject

- (void)saveContacts :(NSArray*)contactIds :(NSArray*)types :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))result;
- (void)deleteContacts :(NSArray*)contactIds :(NSArray*)types :(FMDatabaseQueue*)queue :(void(^)(BOOL isSuccess))result;
- (void)queryContacts:(NSArray *)contactIds :(NSArray *)types :(FMDatabaseQueue*)queue :(void (^)(NSArray *result))result;
- (void)queryAllContacts :(FMDatabaseQueue*)queue :(NSString*)type :(void (^)(NSArray *result))result;
@end
