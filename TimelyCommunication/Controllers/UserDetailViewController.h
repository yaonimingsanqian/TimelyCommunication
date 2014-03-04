//
//  UserDetailViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-4.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserDetailViewController : UITableViewController
{
    User *user;
}

- (id)initWithUser :(User*)auser;
@end
