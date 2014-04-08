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
{
   
}
@end
static int origin;
@implementation ChatViewController
@synthesize username=_username,messageArray=_messageArray;
#pragma mark - ChatDelegate
- (void)sendTextMessage:(NSString *)text
{
    if(text.length <= 0) return;
    TextMessage *message = [[TextMessage alloc]init];
    message.msgContent = text;
    message.type = MessageText;
    message.sendDate = [NSDate date];
    message.conversationId = _username;
    message.to = _username;
    message.from = [CommonData sharedCommonData].curentUser.username;
    message.isIncoming = NO;
    [_messageArray addObject:message];
   
    [[DataStorage sharedInstance] saveMsg:message :^{
         [[Conversation sharedInstance] sendMessage:message];
        if(![[ConversationMgr sharedInstance] isConversationExist:_username])
        {
            [[ConversationMgr sharedInstance].conversations addObject:_username];
            [[DataStorage sharedInstance] saveConversation:_username :nil];
        }
    }];
    [chatViewCompent reloadData];
    
}
#pragma mark - HPLChatTableViewDataSource
- (NSInteger)numberOfRowsForChatTable:(HPLChatTableView *)tableView
{
    return _messageArray.count;
}
- (HPLChatData*)chatTableView:(HPLChatTableView *)tableView dataForRow:(NSInteger)row
{
    HPLChatData *hplData;
    BaseMesage *textMsg = [_messageArray objectAtIndex:row];
    hplData = [[HPLChatData alloc]initWithText:textMsg.msgContent date:textMsg.sendDate type:textMsg.isIncoming];
    
    return hplData;
}

- (id)initWithUserName:(NSString *)ausername
{
    self = [super init];
    if(self)
    {
        _messageArray = [[NSMutableArray alloc]init];
        _username = ausername;
    }
    return self;
}
- (void)receiveNewMsg
{
    [[DataStorage sharedInstance] updateConversation:_username :NO];
    [[DataStorage sharedInstance] loadHistoryMsg:_username :^(NSArray *result) {
        _messageArray = [NSMutableArray arrayWithArray:result];
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
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :_username];
}

- (void)loadMore
{
    [[DataStorage sharedInstance] loadMoreMsg:_username :origin :4 :^(NSArray *result) {
        origin += result.count;
        NSMutableArray *dest = [NSMutableArray arrayWithArray:result];
        [dest addObjectsFromArray:_messageArray];
        _messageArray = dest;
        [_messageArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            BaseMesage *msg1 = (BaseMesage*)obj1;
            BaseMesage *msg2 = (BaseMesage*)obj2;
            if(msg1.messageId < msg2.messageId)
                return  NSOrderedDescending;
            return NSOrderedAscending;
        }];
        [chatViewCompent reloadDataWithoutScrollToBottom];
        [chatViewCompent endRefresh];
    }];
}
- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    chatViewCompent = [[ChatViewCompent alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) delegate:self];
    
    chatViewCompent.delegate = self;
    [self.view addSubview:chatViewCompent];
    
//    [[DataStorage sharedInstance] loadHistoryMsg:username :^(NSArray *result) {
//        messageArray = [NSMutableArray arrayWithArray:result];
//        [chatViewCompent reloadData];
//    }];
    origin = 0;
    [[DataStorage sharedInstance] loadMoreMsg:_username :origin :4 :^(NSArray *result) {
        origin += result.count;
        _messageArray = [NSMutableArray arrayWithArray:result];
        [chatViewCompent reloadData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg) name:kNewTextMsg object:nil];
    //refreshbegin
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMore) name:@"refreshbegin" object:nil];
     [[DataStorage sharedInstance] updateConversation:_username :NO];

    
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
