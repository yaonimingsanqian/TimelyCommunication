//
//  ContactCell.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ContactCell : UITableViewCell
@property (nonatomic,strong)  EGOImageView *avatar;
@property (nonatomic,strong)  UIImageView *rightImage;
@property (nonatomic,strong)  UILabel *name;
@end
