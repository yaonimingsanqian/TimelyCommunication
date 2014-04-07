//
//  MainPageUIViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "MainPageUIViewController.h"
#import "Config.h"
#import "ConversationMgr.h"
#import "DataStorage.h"
#import "ChatViewController.h"
#import "RedBall.h"
#import "MainPageCell.h"
#import "NavigationControllerTitle.h"
#import "DataStorage.h"
@interface MainPageUIViewController ()

@end
@implementation MainPageUIViewController

- (void)dealloc
{
    NSLog(@"MainPageUIViewController dealloc");
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"会话"];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)receiveNewMsg :(NSNotification*)noti
{
    NSDictionary *info = [noti object];
    [[DataStorage sharedInstance] updateConversation:[info objectForKey:kMsgFrom] :YES];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg:) name:kNewTextMsg object:nil];
    [[DataStorage sharedInstance] queryConversation];
    self.tableView.separatorColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ConversationMgr sharedInstance].conversations.count;
}
- (void)clearRedBall :(MainPageCell*)cell
{
    UIView *redball = [cell viewWithTag:12];
    [redball removeFromSuperview];
}
- (void)setCellFontStyle :(MainPageCell*)cell
{
    cell.time.font = [UIFont systemFontOfSize:15.f];
    cell.msg.font = [UIFont systemFontOfSize:15.f];
    cell.uname.font = [UIFont systemFontOfSize:15.f];
    cell.time.textColor = [UIColor lightGrayColor];
    cell.msg.textColor = [UIColor lightGrayColor];
    cell.uname.textColor = [UIColor lightGrayColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MainPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[MainPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.uname = [[UILabel alloc]initWithFrame:CGRectMake(84, 10, 181, 21)];
        cell.avatar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainPage.png"]];
        cell.avatar.frame = CGRectMake(5, 5, 60, 60);
        cell.msg = [[UILabel alloc]initWithFrame:CGRectMake(83, 44, 238, 21)];
        cell.time = [[UILabel alloc]initWithFrame:CGRectMake(171, 10, 137, 21)];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        [cell.contentView addSubview:cell.uname];
        [cell.contentView addSubview:cell.avatar];
        [cell.contentView addSubview:cell.msg];
        [cell.contentView addSubview:cell.time];
    }
    cell.uname .text = nil;
    cell.time.text = nil;
    cell.msg.text = nil;
     NSString *con = [[ConversationMgr sharedInstance].conversations objectAtIndex:indexPath.row];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    
    [[DataStorage sharedInstance] queryLastMsg:[[username componentsSeparatedByString:@"@"] objectAtIndex:0]  :con :^(TextMessage *msg) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *currentDateStr = [dateFormat stringFromDate:msg.sendDate];
        cell.time.text = currentDateStr;
        cell.msg.text = msg.msgContent;
    }];
   
    
    [self clearRedBall:cell];
   
    cell.uname.text = con;
    
    [[DataStorage sharedInstance] queryNotReadCount:con :^(int count) {
        
        UIView *notRead = [RedBall createRedBall:count];
        CGRect frame = notRead.frame;
        frame.origin.y = (cell.frame.size.height - frame.size.height)/2.f;
        notRead.frame = frame;
        [cell.contentView addSubview:notRead];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellFontStyle:cell];
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [[ChatViewController alloc]initWithUserName:[[ConversationMgr sharedInstance].conversations objectAtIndex:indexPath.row]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *con = [[ConversationMgr sharedInstance].conversations objectAtIndex:indexPath.row];
    [[DataStorage sharedInstance] deleteConversation:con :^(BOOL isSuccess) {
        [[ConversationMgr sharedInstance] removeConversations:con];
        [self.tableView reloadData];
        [[DataStorage sharedInstance] deleteMsg:con :nil];
    }];
}

@end
