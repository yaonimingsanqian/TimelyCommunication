//
//  MainPageCell.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MainPageCell : UITableViewCell

@property (nonatomic,strong) EGOImageView *avatar;
@property (nonatomic,strong) UILabel *uname;
@property (nonatomic,strong) UILabel *msg;
@property (nonatomic,strong) UILabel *time;

@end
