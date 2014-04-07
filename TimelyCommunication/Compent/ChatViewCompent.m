//
//  ChatViewCompent.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ChatViewCompent.h"


@implementation ChatViewCompent
{
    BOOL isShowKeyboard;
}

#pragma mark - 私有
- (void)createChatTableView :(id<HPLChatTableViewDataSource>)datsSource
{
    if([[UIScreen mainScreen] bounds].size.height != 480)
    {
        chatTableView = [[HPLChatTableView alloc]initWithFrame:kChatViewFrame];
    }else
    {
        chatTableView = [[HPLChatTableView alloc]initWithFrame:kChatViewFrameForIPHONE4];
    }
    
    chatTableView.chatDataSource = datsSource;
   // chatTableView.backgroundColor = [UIColor greenColor];
    [self addSubview:chatTableView];
}
- (void)createInputFrame
{
    if([[UIScreen mainScreen] bounds].size.height != 480)
    {
        inputCompent = [[InputCompent alloc]initWithFrame:kInputViewFrame :self];
    }else
    {
        inputCompent = [[InputCompent alloc]initWithFrame:kInputViewFrameForIPHONE4 :self];
    }
    
    inputCompent.delegate = self;
    [self addSubview:inputCompent];
}
- (void)listenKeyboardShowAndHide
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)adaptarKeyboardShow :(CGRect)keyboardFrame :(NSTimeInterval)duration
{
   // if(!isShowKeyboard) return;
    [UIView animateWithDuration:duration animations:^{
      //  isShowKeyboard = YES;
        //int h = [[UIScreen mainScreen] bounds].size.height;
       // int offset = h > 480?0:-64;
        CGRect inputCompentFrame = inputCompent.frame;
        inputCompentFrame.origin.y = [[UIScreen mainScreen] bounds].size.height - keyboardFrame.size.height-inputCompent.frame.size.height-64;
        inputCompent.frame = inputCompentFrame;
        CGRect chatTableViewFrame = chatTableView.frame;
        chatTableViewFrame.size.height = inputCompent.frame.origin.y;
        chatTableView.frame = chatTableViewFrame;
        [chatTableView scrollToBottomAnimated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)adapterKeyboardHide :(CGRect)keyboardFrame :(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
      //  isShowKeyboard = NO;
      //  int h = [[UIScreen mainScreen] bounds].size.height;
       // int offset = h > 480?0:-64;
        CGRect inputCompentFrame = inputCompent.frame;
        inputCompentFrame.origin.y = [[UIScreen mainScreen] bounds].size.height-inputCompent.frame.size.height-64;
        inputCompent.frame = inputCompentFrame;
        CGRect chatTableViewFrame = chatTableView.frame;
        chatTableViewFrame.size.height = inputCompent.frame.origin.y;
        chatTableView.frame = chatTableViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)keyboardShow :(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self adaptarKeyboardShow:keyboardRect :animationDuration];
}
- (void)keyboardHide :(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self adapterKeyboardHide:keyboardRect :animationDuration];
}
- (void)chatTableViewTapAction :(UITapGestureRecognizer*)tap
{
    [inputCompent hideKeyboard];
}
#pragma mark - 接口
- (void)reloadData
{
    [chatTableView reloadData];
    [chatTableView scrollToBottomAnimated:YES];
}
- (id)initWithFrame:(CGRect)frame delegate:(id<HPLChatTableViewDataSource>)dataSource
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createChatTableView:dataSource];
        [chatTableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatTableViewTapAction:)]];
        [self createInputFrame];
        [self listenKeyboardShowAndHide];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma - mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if ([text isEqualToString:@"\n"]) {
        
       // [textView resignFirstResponder];
        [self.delegate sendTextMessage:textView.text];
        textView.text = nil;
        return NO;
    }
    return YES;
    
}
@end
