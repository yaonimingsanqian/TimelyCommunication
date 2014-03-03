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
#import "ChatViewController.h"
#import "RedBall.h"
@interface MainPageUIViewController ()

@end

@implementation MainPageUIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)receiveNewMsg :(NSNotification*)noti
{
    NSString *user = [noti object];
    [[ConversationMgr sharedInstance] updateConversation:user :YES];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMsg:) name:kNewTextMsg object:nil];
    [[ConversationMgr sharedInstance] queryConversation];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ConversationMgr sharedInstance].conversations.count;
}
- (void)clearRedBall :(UITableViewCell*)cell
{
    UIView *redball = [cell viewWithTag:12];
    [redball removeFromSuperview];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [self clearRedBall:cell];
    NSString *con = [[ConversationMgr sharedInstance].conversations objectAtIndex:indexPath.row];
    cell.textLabel.text = con;
    
    UIView *notRead = [RedBall createRedBall:[[ConversationMgr sharedInstance] queryNotReadCount:con]];
    CGRect frame = notRead.frame;
    frame.origin.y = (cell.frame.size.height - frame.size.height)/2.f;
    notRead.frame = frame;
    [cell.contentView addSubview:notRead];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [[ChatViewController alloc]initWithUserName:[[ConversationMgr sharedInstance].conversations objectAtIndex:indexPath.row]];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
