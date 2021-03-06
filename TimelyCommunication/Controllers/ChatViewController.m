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
#import<CommonCrypto/CommonDigest.h>
#import <PArse/Parse.h>
#import "URLCache.h"
@interface ChatViewController ()
{
    __block BOOL shouldSendTyping;
}
@end
static int origin;
@implementation ChatViewController
@synthesize username=_username,messageArray=_messageArray;
#pragma mark - ChatDelegate

- (NSString *)md5 :(NSString*)source
{
    const char *cStr = [source UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
- (void)sendTextMessage:(NSString *)text
{
    if(text.length <= 0) return;
    TextMessage *message = [[TextMessage alloc]init];
    message.msgContent = text;
    message.type = @"chat";
    message.sendDate = [NSDate date];
    message.conversationId = _username;
    message.to = _username;
    message.from = [CommonData sharedCommonData].curentUser.username;
    message.isIncoming = NO;
    message.messageId = [self md5:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    message.status = MsgStatusSending;
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
    
    int status = textMsg.status;

    [hplData setMessageStatus:status];
    if(textMsg.from == nil) textMsg.from = [CommonData sharedCommonData].curentUser.username ;
    textMsg.from = [[textMsg.from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSString *urlStr = [[URLCache sharedInstance] queryURLWithkey:textMsg.from type:CacheTypePerson];
    if(!urlStr)
    {
        [[DataStorage sharedInstance] queryPersonDetail:[NSArray arrayWithObject:textMsg.from] :^(NSArray *resultDic, NSError *error) {
            
            if(resultDic.count > 0)
            {
                NSDictionary *info = [resultDic firstObject];
                hplData.avatarView.imageURL = [NSURL URLWithString:[info objectForKey:@"avatar"]];
                [[URLCache sharedInstance] cacheURLStr:[info objectForKey:@"avatar"] name:textMsg.from type:CacheTypePerson];
            }else
            {
                PFQuery *query = [PFUser query];
                [query whereKey:@"username" equalTo:textMsg.from];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if(objects.count > 0)
                    {
                        PFObject *obj = [objects firstObject];
                        PFFile *avatar = obj[@"avatar"];
                        [[DataStorage sharedInstance] updatePersonInfo:[NSDictionary dictionaryWithObjectsAndKeys:avatar.url,@"avatar",textMsg.from,@"username", nil] :nil];
                        [[URLCache sharedInstance] cacheURLStr:avatar.url name:textMsg.from type:CacheTypePerson];
                        hplData.avatarView.imageURL = [NSURL URLWithString:avatar.url];
                    }
                }];
            }
        }];
    }else
    {
        hplData.avatarView.imageURL = [NSURL URLWithString:urlStr];
    }
    
    
   
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
//    [[DataStorage sharedInstance] loa];
//    [[DataStorage sharedInstance] loadHistoryMsg:_username :^(NSArray *result) {
//        
//    }];
    [[DataStorage sharedInstance] queryLastMsg:nil :_username :^(TextMessage *msg) {
        [_messageArray addObject:msg];
        [chatViewCompent reloadDataWithOutAnimation];
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
    shouldSendTyping = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    chatViewCompent = [[ChatViewCompent alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) delegate:self :^(NSString *text) {
        
//        if(shouldSendTyping)
//        {
//            shouldSendTyping = NO;
//            [[Conversation sharedInstance] pushEnter:_username];
//        }
//        if(text.length <= 0)
//        {
//            shouldSendTyping = YES;
//        }
        
    }];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSendStatus:) name:kSendMsgSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSendStatus:) name:kSendMsgFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgSendStatus:) name:kSendMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buddyTyping) name:kBuddyTyping object:nil];
     [[DataStorage sharedInstance] updateConversation:_username :NO];

    
}
- (void)revert
{
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :_username];
}
- (void)buddyTyping
{
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"对方正在输入..."];
    [self performSelector:@selector(revert) withObject:nil afterDelay:2.f];
}
- (void)reloadData
{
    [chatViewCompent reloadData];
}
- (void)msgSendStatus :(NSNotification*)noti
{
    NSString *msgId = [noti object];
    for (TextMessage *msg in _messageArray)
    {
        if([msg.messageId isEqualToString:msgId])
        {
            if([[noti name] isEqualToString:kSendMsgSuccess])
            {
                 msg.status = MsgStatusSuccess;
            }else if([[noti name] isEqualToString:kSendMsgFailed])
            {
                msg.status = MsgStatusFailed;
            }else
            {
                msg.status = MsgStatusSend;
            }
           
            break;
        }
    }
    [self performSelector:@selector( reloadData) withObject:nil afterDelay:0.4f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"ChatViewController dealloc");
}
@end
