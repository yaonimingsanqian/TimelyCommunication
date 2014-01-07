//
//  InputCompent.h
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface InputCompent : UIView
{
    @private
    UIButton *soundAndTextBtn;
    UIButton *faceBtn;
    UIButton *moreBtn;
    UITextView *inputTextView;
    
}
@property (nonatomic,assign) id<UITextViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame :(id<UITextViewDelegate>)delegate;
- (void)hideKeyboard;
@end
