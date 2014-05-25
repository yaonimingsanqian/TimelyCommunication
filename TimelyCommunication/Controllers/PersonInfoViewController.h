//
//  PersonInfoViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>
@interface PersonInfoViewController : UIViewController
{
    User *user;
}
- (id)initWithUser :(User*)auser;
@property (nonatomic,strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,strong) IBOutlet UIImageView *gender;
@property (nonatomic,strong) IBOutlet UILabel *username;
@property (nonatomic,strong) IBOutlet UILabel *address;
@property (nonatomic,strong) IBOutlet UILabel *age;
@property (nonatomic,strong) IBOutlet UIButton *operation;
@property (nonatomic,strong) PFObject *pfObject;
- (IBAction)addFriend:(id)sender;
@end
