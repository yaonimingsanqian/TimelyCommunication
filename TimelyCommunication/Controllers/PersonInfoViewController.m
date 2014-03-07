//
//  PersonInfoViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-7.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "ContactsMgr.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

- (id)initWithUser:(User *)auser
{
    self = [super init];
    if(self)
    {
        user = auser;
    }
    return self;
}
- (BOOL)isThePersonMyFriend :(NSString*)name
{
    for (NSString *person in [ContactsMgr sharedInstance].friends)
    {
        if([person isEqualToString:name])
            return YES;
    }
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.text = user.username;
    self.address.text = user.address;
    self.age.text = user.age;
    if([user.gender isEqualToString:@"man"])
    {
        self.gender.image = [UIImage imageNamed:@"man"];
    }else
    {
        self.gender.image = [UIImage imageNamed:@"woman"];
    }
    if([self isThePersonMyFriend:user.username])
        [self.operation setTitle:@"发送消息" forState:UIControlStateNormal];
    else
        [self.operation setTitle:@"加为好友" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
