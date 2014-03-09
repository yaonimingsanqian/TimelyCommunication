//
//  NavigationControllerTitle.h
//  TimelyCommunication
//
//  Created by zhao on 14-3-9.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationControllerTitle : NSObject
+ (void)showInView :(UIView*)view :(NSString*)title;
+ (void)hide :(UIView*)view;
@end
