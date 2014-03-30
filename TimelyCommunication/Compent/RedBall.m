//
//  RedBall.m
//  changjianghui
//
//  Created by zhao on 13-12-18.
//  Copyright (c) 2013年 guo song. All rights reserved.
//

#import "RedBall.h"
#import "Config.h"

//CGRectMake(60, 10, 18, 18)
@implementation RedBall

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (UIView*)createTimeCompent:(NSDate *)date
{
    UILabel * msgDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 20, 80, 21)];
    msgDateLabel.textAlignment = NSTextAlignmentRight;
    msgDateLabel.font = [UIFont systemFontOfSize:13.0f];
    msgDateLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0];
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSLog(@"cmp1 hour = %d",[cmp1 hour]);
    NSLog(@"cmp2 hour = %d",[cmp2 hour]);
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day])
    { // 今天
        //        formatter.dateFormat = @"今天 HH:mm";
        formatter.dateFormat = @"a HH:mm";
    }
    //    else if ([cmp1 year] == [cmp2 year])// 今年
    else if ([cmp1 weekday] == [cmp2 weekday])
    {
        //        formatter.dateFormat = @"MM-dd HH:mm";
        formatter.dateFormat = @"cccc";
    }
    else
    {
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        formatter.dateFormat = @"yy-MM-dd";
    }
    msgDateLabel.text = [formatter stringFromDate:date];
    return msgDateLabel;
}
+ (UIView*)createRedBallWithoutNumber
{
    UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-28, 10, 10)];
    portrait.backgroundColor = [UIColor redColor];
    portrait.layer.masksToBounds = YES;
    portrait.layer.cornerRadius = portrait.frame.size.width/2.f;
    portrait.tag = kRedPointTag;
    return portrait;
}

+ (UIView*)createRedBall:(int)count
{
    if(count == 0) return nil;
    //count = 9;
    UIImageView *portrait = [[UIImageView alloc] initWithFrame:CGRectMake(280, 25, 30, 20)];
    UILabel *labelCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
   // NSLog(@"%f",font.systemFontSize);
    //labelCount.font = [UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>];
    labelCount.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    labelCount.textAlignment = NSTextAlignmentCenter;
    if(count >= 100)
    {
        portrait.frame = CGRectMake(280, 25, 30, 20);
        labelCount.frame = CGRectMake(0, 0, 30, 20);
        labelCount.font = [UIFont fontWithName:@"Helvetica" size:12];
    }
    labelCount.backgroundColor = [UIColor clearColor];
    labelCount.text = [NSString stringWithFormat:@"%d",count];
    labelCount.textColor = [UIColor whiteColor];
    [portrait addSubview:labelCount];
//    portrait.tintColor = [UIColor redColor];
    portrait.backgroundColor = [UIColor redColor];
    portrait.layer.masksToBounds = YES;
    portrait.layer.cornerRadius = portrait.frame.size.width/3.f;
    portrait.tag = 12;
    return portrait;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
