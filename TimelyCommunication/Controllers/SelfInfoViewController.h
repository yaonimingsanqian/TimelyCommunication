//
//  SelfInfoViewController.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfInfoViewController : UIViewController

@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UILabel *address;
@property(nonatomic,strong) IBOutlet UILabel *age;

-(IBAction)logout:(UIButton*)sender;
@end
