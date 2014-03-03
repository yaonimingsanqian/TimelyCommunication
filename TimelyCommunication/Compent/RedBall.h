//
//  RedBall.h
//  changjianghui
//
//  Created by zhao on 13-12-18.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RedBall : UIView

+ (UIView*)createRedBall :(int)count;
+ (UIView*)createTimeCompent :(NSDate*)date;
@end
