//
//  NavigationControllerTitle.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "NavigationControllerTitle.h"

@implementation NavigationControllerTitle

+ (void)showInView:(UIView *)view :(NSString *)title
{
    CGSize  sizeOfStr = [title sizeWithFont:
                         [UIFont boldSystemFontOfSize:17.0f]
                             constrainedToSize:CGSizeMake(240.0f, 480.0f)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = CGRectMake((320-sizeOfStr.width)/2, 0, sizeOfStr.width, 44);
    UILabel *labelTitle = [[UILabel alloc]init];
    labelTitle.frame = frame;
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:17];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = title;
    labelTitle.tag = 110;
    [view addSubview:labelTitle];
}
+ (void)hide :(UIView*)view
{
    [[view viewWithTag:110] removeFromSuperview];
}
@end
