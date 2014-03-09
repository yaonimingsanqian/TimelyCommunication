//
//  ViewController.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "ChatViewController.h"
#import "TextMessage.h"
#import "iPhoneXMPPAppDelegate.h"
#import "ConversationMgr.h"
#import "DataStorage.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
#pragma mark - ChatDelegate
- (void)sendTextMessage:(NSString *)text
{
    TextMessage *message = [[TextMessage alloc]init];
    message.msgContent = text;
    message.type = MessageText;
    message.sendDate = [NSDate date];
    message.conversationId = username;
    message.to = username;
    message.from = [CommonData sharedCommonData].curentUser.username;
    message.isIncoming = NO;
    [messageArray addObject:message];
    [[Conversation sharedInstance] sendMessage:message];
    [[DataStorage sharedInstance] saveMsg:message];
    [chatViewCompent reloadData];
    if(![[ConversationMgr sharedInstance] isConversationExist:username])
    {
        [[ConversationMgr sharedInstance].conversations addObject:username];
        [[DataStorage sharedInstance] saveConversation:username];
    }
}
#pragma mark - HPLChatTableViewDataSource
- (NSInteger)numberOfRowsForChatTable:(HPLChatTableView *)tableView
{
    return messageArray.count;
}
- (HPLChatData*)chatTableView:(HPLChatTableView *)tableView dataForRow:(NSInteger)row
{
    HPLChatData *hplData;
    BaseMesage *textMsg = [messageArray objectAtIndex:row];
    hplData = [[HPLChatData alloc]initWithText:textMsg.msgContent date:textMsg.sendDate type:textMsg.isIncoming];
    
    return hplData;
}

- (id)initWithUserName:(NSString *)ausername
{
    self = [super init];
    if(self)
    {
        messageArray = [[NSMutableArray alloc]init];
        username = ausername;
    }
    return self;
}
- (void)receiveNewMsg
{
    [[DataStorage sharedInstance] updateConversation:username :NO];
    messageArray = [NSMutableArray arrayWithArray:[[DataStorage sharedInstance] loadHistoryMsg:username]];
    [chatViewCompent reloadData];
}
#pragma mark - 系统方法
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    chatViewCompent = [[ChatViewCompent alloc]initWithFrame:[[UIScreen mainScreen] bounds] delegate:self];
    
    chatViewCompent.delegate = self;
    [self.view addSubview:chatViewCompent];
    messageArray = [NSMutableArray arrayWithArray:[[DataStorage sharedInstance] loadHistoryMsg:username] ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg) name:kNewTextMsg object:nil];
     [[DataStorage sharedInstance] updateConversation:username :NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
