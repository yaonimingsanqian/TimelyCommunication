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
#import "NavigationControllerTitle.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
#pragma mark - ChatDelegate
- (void)sendTextMessage:(NSString *)text
{
    if(text.length <= 0) return;
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
    [[DataStorage sharedInstance] saveMsg:message :nil];
    [chatViewCompent reloadData];
    if(![[ConversationMgr sharedInstance] isConversationExist:username])
    {
        [[ConversationMgr sharedInstance].conversations addObject:username];
        [[DataStorage sharedInstance] saveConversation:username :nil];
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
    [[DataStorage sharedInstance] loadHistoryMsg:username :^(NSArray *result) {
        messageArray = [NSMutableArray arrayWithArray:result];
        [chatViewCompent reloadData];
    }];
    
}
#pragma mark - 系统方法
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :username];
}
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    chatViewCompent = [[ChatViewCompent alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) delegate:self];
    
    chatViewCompent.delegate = self;
    [self.view addSubview:chatViewCompent];
    
    [[DataStorage sharedInstance] loadHistoryMsg:username :^(NSArray *result) {
        messageArray = [NSMutableArray arrayWithArray:result];
        [chatViewCompent reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg) name:kNewTextMsg object:nil];
     [[DataStorage sharedInstance] updateConversation:username :NO];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"ChatViewController dealloc");
}
@end
