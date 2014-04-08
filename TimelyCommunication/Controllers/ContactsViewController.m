//
//  ContactsViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-2.
//  Copyright (c) 2014年 zhao. All rights reserved.
//
#import "ContactsMgr.h"
#import "ContactsViewController.h"
#import "ChatViewController.h"
#import "NewFriendViewController.h"
#import "SearchFriendViewController.h"
#import "Config.h"
#import "NavigationControllerTitle.h"
#import "ContactCell.h"
#import "SMQuery.h"
#import "SMClient.h"
#import "CommonData.h"
#import "MBProgressHUD.h"
#import "RedBall.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"通讯录"];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kRefeshcontact object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:kContactLoadFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendApply:) name:kNewFriendApply object:nil];
}
- (void)newFriendApply :(NSNotification*)noti
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIView *redball = [RedBall createRedBallWithoutNumber];
    CGRect frame = redball.frame;
    frame.origin.x = 270;
    frame.origin.y = (cell.frame.size.height - frame.size.height)/2.f;
    redball.frame = frame;
    [cell.contentView addSubview:redball];
}
- (void)reloadTableView :(NSNotification*)noti
{
    [self.tableView reloadData];
}
- (BOOL)isFriendExist :(NSString*)uname
{
    for (NSString *friend in [ContactsMgr sharedInstance].friends)
    {
        if([friend isEqualToString:uname])
            return YES;
    }
    return NO;
}
- (void)refresh :(NSNotification*)noti
{
    NSDictionary *info = [noti object];
    if([[info objectForKey:kRefreshtype] isEqualToString:kNewFriend] || [[info objectForKey:kRefreshtype] isEqualToString:kNewTextMsg])
    {
        if(![self isFriendExist:[info objectForKey:kMsgFrom]])
        {
            [[ContactsMgr sharedInstance].friends addObject:[info objectForKey:kMsgFrom]];
            
        }
    }else if([[info objectForKey:kRefreshtype] isEqualToString:kDeleteFriend])
    {
        for (NSString *contact in [ContactsMgr sharedInstance].friends)
        {
            if([contact isEqualToString:[info objectForKey:kMsgFrom]])
            {
                [[ContactsMgr sharedInstance].friends removeObject:contact];
                [[NSNotificationCenter defaultCenter] postNotificationName:kContactDeleteOne object:contact userInfo:nil];
                break;
            }
        }
    }
    
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    return [ContactsMgr sharedInstance].friends.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        cell.name = [[UILabel alloc]initWithFrame:CGRectMake(77, 17, 229, 21)];
        cell.name.font = [UIFont systemFontOfSize:15.f];
        cell.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, 20,20,20)];
        [cell.contentView addSubview:cell.avatar];
        [cell.contentView addSubview:cell.name];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, 320, 1)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
        [cell.contentView addSubview:cell.rightImage];
    }
    cell.name.text = nil;
    cell.avatar.image = nil;
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.name.text = @"朋友申请";
            cell.avatar.image = [UIImage imageNamed:@"friend.png"];
            
        }else
        {
            
            cell.name.text = @"添加好友";
            cell.avatar.image = [UIImage imageNamed:@"searchfriend.png"];
           
        }
        cell.rightImage.image = [UIImage imageNamed:@"next.png"];
        
    }else
    {
        cell.avatar.image = [UIImage imageNamed:@"mainPage.png"];
        cell.name.text = [[ContactsMgr sharedInstance].friends objectAtIndex:indexPath.row];
    }
    
    
    cell.showsReorderControl = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            for (UIView *view in cell.contentView.subviews)
            {
                if(view.tag == kRedPointTag)
                {
                    [view removeFromSuperview];
                    break;
                }
            }
            NewFriendViewController *newfriendVC = [[NewFriendViewController alloc]init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.backBarButtonItem = backItem;
            backItem.title = @"返回";
            newfriendVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newfriendVC animated:YES];
            return;
        }else
        {
            SearchFriendViewController *search = [[SearchFriendViewController alloc]init];
            search.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:search animated:YES];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.backBarButtonItem = backItem;
            backItem.title = @"返回";
            return;
        }
        
    }
    ChatViewController *chatVC = [[ChatViewController alloc]initWithUserName:[[ContactsMgr sharedInstance].friends objectAtIndex:indexPath.row]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return NO;
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)handleError
{
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络请求发生错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //更新自己的朋友列表
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    NSString *friendId = [[ContactsMgr sharedInstance].friends objectAtIndex:indexPath.row];
    NSString *meId = [CommonData sharedCommonData].curentUser.username;
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:meId];
    [[[SMClient defaultClient] dataStore] performQuery:query  onSuccess:^(NSArray *results) {
        NSDictionary *meinfo = [results objectAtIndex:0];
        NSMutableArray *friends = [NSMutableArray arrayWithArray:[meinfo objectForKey:@"friends"]];
        for (NSString *friend in friends)
        {
            if([friend isEqualToString:friendId])
            {
                [friends removeObject:friend];
                break;
            }
        }
        NSDictionary *update = [NSDictionary dictionaryWithObjectsAndKeys:friends,@"friends", nil];
        [[[SMClient defaultClient] dataStore] updateObjectWithId:meId inSchema:@"user" update:update onSuccess:^(NSDictionary *object, NSString *schema) {
            //更新对方的朋友列表
            SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
            [query where:@"username" isEqualTo:friendId];
            [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
                NSDictionary *userinfo = [results objectAtIndex:0];
                NSMutableArray *friends = [NSMutableArray arrayWithArray:[userinfo objectForKey:@"friends"]];
                for (NSString *friend in friends)
                {
                    if([friend isEqualToString:meId])
                    {
                        [friends removeObject:friend];
                        break;
                    }
                }
                NSDictionary *update = [NSDictionary dictionaryWithObjectsAndKeys:friends,@"friends", nil];
                [[[SMClient defaultClient] dataStore] updateObjectWithId:friendId inSchema:@"user" update:update onSuccess:^(NSDictionary *object, NSString *schema) {
                    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                    //发送推送给对方
                    [[Conversation sharedInstance] pushDeleteContact:friendId];
                    //更新自己的好友列表
                     [[ContactsMgr sharedInstance].friends removeObjectAtIndex:indexPath.row];
                     [tableView reloadData];
                    
                } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                    [self handleError];
                }];
            } onFailure:^(NSError *error) {
                [self handleError];
            }];
            
        } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
            [self handleError];
        }];
    } onFailure:^(NSError *error) {
        [self handleError];
    }];
     
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return @"删除";
}
- (void)dealloc
{
    NSLog(@"ContactsViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kContactLoadFinish object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefeshcontact object:nil];
}

@end
