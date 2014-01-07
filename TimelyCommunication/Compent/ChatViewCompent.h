//
//  ChatViewCompent.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewCompent.h"
#import "HPLChatTableView.h"
#import "InputCompent.h"

@protocol ChatDelegate
@required
- (void)sendTextMessage :(NSString*)text;
@end

@interface ChatViewCompent : UIView<UITextViewDelegate>
{
    @private
    HPLChatTableView *chatTableView;
    InputCompent *inputCompent;
}
@property (nonatomic,assign) id<ChatDelegate> delegate;
- (id)initWithFrame :(CGRect)frame delegate:(id<HPLChatTableViewDataSource>)dataSource;
- (void)reloadData;
@end
