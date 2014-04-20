//
//  NaviItems.m
//  changjianghui
//
//  Created by OO on 14-3-27.
//  Copyright (c) 2014年 guo song. All rights reserved.
//

#import "NaviItems.h"

@implementation NaviItems
+(UILabel*)naviTitleViewWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    CGSize size=CGSizeZero;
    if (IOS7) {
        size=[title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NaviTitleFont,NSFontAttributeName,nil]];
    }else{
        size=[title sizeWithFont:NaviTitleFont];
    }
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 44)];
    titleLabel.font=NaviTitleFont;
    titleLabel.textColor=NaviTitleColor;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=title;
    return titleLabel;
}
+(UIBarButtonItem*)naviLeftBtnWithImage:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}
+(UIBarButtonItem*)naviLeftBtnWithImage:(UIImage *)image target:(id)target selector:(SEL)selector action:(UIControlEvents)event{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:target action:selector forControlEvents:event];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}
+(UIBarButtonItem*)naviRightBtnWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    CGSize size=CGSizeZero;
    if (IOS7) {
        size=[title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NaviRightBtnFont,NSFontAttributeName,nil]];
    }else{
        size=[title sizeWithFont:NaviRightBtnFont];
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, size.width+15, 50);
    btn.titleLabel.font=NaviRightBtnFont;
    btn.titleLabel.textColor = [UIColor blueColor];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}
+(UIBarButtonItem*)naviRightBtnWithImage:(UIImage *)image target:(id)target selector:(SEL)selector{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}

+(UIBarButtonItem*)naviLeftBtnWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    CGSize size=CGSizeZero;
    if (IOS7) {
        size=[title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NaviRightBtnFont,NSFontAttributeName,nil]];
    }else{
        size=[title sizeWithFont:NaviRightBtnFont];
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, size.width+8, 44);
    btn.titleLabel.font=NaviRightBtnFont;
    btn.titleLabel.textColor=[UIColor blackColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}

@end
