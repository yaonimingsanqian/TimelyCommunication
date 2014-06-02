//
//  ChatViewCompent.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ChatViewCompent.h"
#import "Conversation.h"
typedef void(^Typing)(NSString *text);

@implementation ChatViewCompent
{
    BOOL isShowKeyboard;
    Typing typing;
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
    refreshView = [[MJRefreshHeaderView alloc]init];
    refreshView.delegate = self;
    refreshView.scrollView = chatTableView;
    chatTableView.chatDataSource = datsSource;
    chatTableView.showAvatars = YES;
    
    [self addSubview:chatTableView];
}
- (void)endRefresh
{
    [refreshView endRefreshing];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshbegin" object:nil];
}
- (void)resizeInputCompent
{
    CGRect currentFrame = inputCompent.frame;
    currentFrame.size.height = kInputViewFrame.size.height;
    if([[UIScreen mainScreen] bounds].size.height != 480)
    {
        inputCompent.frame = currentFrame;
    }else
    {
        inputCompent.frame = currentFrame;
    }
    CGRect currentInputTextFrame = inputCompent.inputTextView.frame;
    currentInputTextFrame.size.height = kInputTextFrame.size.height;
    inputCompent.inputTextView.frame = currentInputTextFrame;
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
        inputCompentFrame.origin.y = [[UIScreen mainScreen] bounds].size.height - keyboardFrame.size.height-inputCompent.frame.size.height;
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
        inputCompentFrame.origin.y = [[UIScreen mainScreen] bounds].size.height-inputCompent.frame.size.height;
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
- (void)reloadDataWithOutAnimation
{
    [chatTableView reloadData];
    [chatTableView scrollToBottomAnimated:NO];
}
- (void)reloadDataWithoutScrollToBottom
{
    [chatTableView reloadWithOutScroll];
}
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
- (id)initWithFrame:(CGRect)frame delegate:(id<HPLChatTableViewDataSource>)dataSource :(void (^)(NSString *))atyping
{
    self = [super initWithFrame:frame];
    if (self)
    {
        typing = atyping;
        [self createChatTableView:dataSource];
        [chatTableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatTableViewTapAction:)]];
        [self createInputFrame];
        [self listenKeyboardShowAndHide];
        
    }
    return self;
}
- (void)dealloc
{
    [refreshView free];
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

- (CGRect)caculateNewFrame :(CGSize)offsetSize :(CGRect)destFrame
{
    CGFloat offset = offsetSize.height - destFrame.size.height;
    destFrame.origin.y -= offset;
    destFrame.size.height = offsetSize.height;
    return destFrame;
}
#pragma - mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.contentSize.height > kInputMaxHeight) return;
    CGRect inputTextFrame = inputCompent.inputTextView.frame;
    CGRect newInputTextFrame = [self caculateNewFrame:textView.contentSize :inputTextFrame];
    CGFloat offset = newInputTextFrame.size.height - inputTextFrame.size.height;
        
    CGRect inputCompentFrame = inputCompent.frame;
    inputCompentFrame.size.height += offset;
    inputCompentFrame.origin.y -= offset;
    inputCompent.frame = inputCompentFrame;
    newInputTextFrame.origin.y = kInpuTextFrameOriginYOffset;
    inputCompent.inputTextView.frame = newInputTextFrame;
    
    CGRect chatTableViewFrame = chatTableView.frame;
    chatTableViewFrame.size.height = inputCompent.frame.origin.y;
    chatTableView.frame = chatTableViewFrame;
    [chatTableView scrollToBottomAnimated:NO];
    if(typing)
    {
        typing(textView.text);
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if ([text isEqualToString:@"\n"]) {
        
       // [textView resignFirstResponder];
        [self.delegate sendTextMessage:textView.text];
        [self resizeInputCompent];
        textView.text = nil;
        return NO;
    }
    return YES;
    
}
@end
