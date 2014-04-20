//
//  NaviItems.h
//  changjianghui
//
//  Created by OO on 14-3-27.
//  Copyright (c) 2014年 guo song. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef NaviTitleFont
#define NaviTitleFont [UIFont boldSystemFontOfSize:22]
#endif
#ifndef NaviTitleColor
#define NaviTitleColor [UIColor whiteColor]
#endif
#ifndef NaviRightBtnColor
#define NaviRightBtnColor [UIColor blackColor]
#endif
#ifndef NaviRightBtnFont
#define NaviRightBtnFont [UIFont systemFontOfSize:17]
#endif
@interface NaviItems : NSObject
//无事件传nil;
+(UIBarButtonItem*)naviLeftBtnWithImage:(UIImage*)image target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviRightBtnWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;
+(UILabel*)naviTitleViewWithTitle:(NSString*)title target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviRightBtnWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
+(UIBarButtonItem*)naviLeftBtnWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
@end