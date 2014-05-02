//
//  MyViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-4-22.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "MyViewController.h"
#import "CommonData.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Config.h"
#import "ConversationMgr.h"
#import "ContactsMgr.h"
#import "MBProgressHUD.h"
#import "DataStorage.h"
#import "LoginViewController.h"
@interface MyViewController ()
{
    MBProgressHUD *waiting;
}
@end

@implementation MyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor = [UIColor clearColor];
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
        return 3;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  static *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, 320, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
    }
    UIView *view = [cell.contentView viewWithTag:10];
    [view removeFromSuperview];
     UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 290, cell.frame.size.height)];
    if(indexPath.section == 0)
    {
       
        label.tag = 10;
        if(indexPath.row == 0)
        {
            label.text = [NSString stringWithFormat:@"姓名:  %@",[CommonData sharedCommonData].curentUser.username == nil?@"未知":[CommonData sharedCommonData].curentUser.username];
        }else if(indexPath.row == 1)
        {
            label.text = [NSString stringWithFormat:@"地址:  %@",[CommonData sharedCommonData].curentUser.address==nil?@"未知":[CommonData sharedCommonData].curentUser.address];
        }else if(indexPath.row == 2)
        {
            label.text = [NSString stringWithFormat:@"年龄:  %@",[CommonData sharedCommonData].curentUser.age==nil?@"未知":[CommonData sharedCommonData].curentUser.age];
        }
        [cell.contentView addSubview:label];
    }else
    {
        label.text = @"退出";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"个人资料"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)logout:(UIButton *)sender
{
    
    waiting =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waiting.labelText = @"正在退出";
    [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
        iPhoneXMPPAppDelegate *delegate = (iPhoneXMPPAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate logout];
        [[ConversationMgr sharedInstance] destoryData];
        [[ContactsMgr sharedInstance] destoryData];
        [[CommonData sharedCommonData] destoryData];
        [DataStorage destory];
        delegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onFailure:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"您退出后将清楚密码，但是历史数据会保存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [sheet showInView:self.tableView];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self logout:nil];
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
