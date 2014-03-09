//
//  AgreenApplyMessage.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-8.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "AgreenApplyMessage.h"
#import "Config.h"

@implementation AgreenApplyMessage

- (void)doSelfThing
{
    [super doSelfThing];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:[[self.from componentsSeparatedByString:@"@"] objectAtIndex:0]];
}
@end
