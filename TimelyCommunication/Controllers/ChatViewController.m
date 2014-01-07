//
//  ViewController.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ChatViewController.h"
#import "TextMessage.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
#pragma mark - ChatDelegate
- (void)sendTextMessage:(NSString *)text
{
    TextMessage *message = [[TextMessage alloc]init];
    message.to = conversation.otherSideId;
    message.msgContent = text;
    message.type = MessageText;
    message.sendDate = [NSDate date];
    message.conversationId = @"test";
    message.isIncoming = NO;
    [messageArray addObject:message];
    [conversation sendMessage:message];
    [conversation saveMsg:message];
    [chatViewCompent reloadData];
}
#pragma mark - HPLChatTableViewDataSource
- (NSInteger)numberOfRowsForChatTable:(HPLChatTableView *)tableView
{
    return messageArray.count;
}
- (HPLChatData*)chatTableView:(HPLChatTableView *)tableView dataForRow:(NSInteger)row
{
    HPLChatData *hplData;
    BaseMesage *message = [messageArray objectAtIndex:row];
    if(message.type == MessageText)
    {
       TextMessage *textMsg = (TextMessage*)message;
        hplData = [[HPLChatData alloc]initWithText:textMsg.msgContent date:textMsg.sendDate type:textMsg.isIncoming];
    }
    return hplData;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        conversation = [[Conversation alloc]init];
        messageArray = [[NSMutableArray alloc]init];
    }
    return self;
}
#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",DATABASE_PATH(@"zhaogwhebust"));
    self.view.backgroundColor = [UIColor whiteColor];
    chatViewCompent = [[ChatViewCompent alloc]initWithFrame:[[UIScreen mainScreen] bounds] delegate:self];
    chatViewCompent.delegate = self;
    [self.view addSubview:chatViewCompent];
    [CommonData sharedCommonData].curentUser.account = @"zhaogwhebust";
    conversation = [[Conversation alloc]init];
    messageArray = [NSMutableArray arrayWithArray:[conversation loadHistoryMsg]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
