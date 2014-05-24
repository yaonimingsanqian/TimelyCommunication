//
//  DeleteContactMsg.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-29.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "DeleteContactMsg.h"
#import "Config.h"
#import <Parse/Parse.h>
#import "CommonData.h"
@implementation DeleteContactMsg

- (void)doSelfThing
{
    NSString *fromwhere = [[self.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kDeleteFriend,kRefreshtype,fromwhere,kMsgFrom, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:info];
    
    PFQuery *pqueryMe = [[PFQuery alloc]initWithClassName:@"social"];
    [pqueryMe whereKey:@"username" equalTo:[CommonData sharedCommonData].curentUser.username];
    [pqueryMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *me = [objects objectAtIndex:0];
        NSMutableArray *friends = [NSMutableArray arrayWithArray:me[@"friends"]];
        for (NSString *friend in friends)
        {
            if([friend isEqualToString:fromwhere])
            {
                [friends removeObject:friend];
                break;
            }
        }
        me[@"friends"] = friends;
        [me saveEventually];
    }];
    
}
@end
