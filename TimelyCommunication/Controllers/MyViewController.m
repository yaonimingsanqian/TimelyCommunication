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
#import "ContactCell.h"
#import "KeychainItemWrapper.h"
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1) return 80;
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  static *reuseIdentifier = @"reuseIdentifier";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, cell.frame.size.height-0.5, 320, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(15, (cell.frame.size.height-20)/2, 20, 20)];
        cell.name = [[UILabel alloc]initWithFrame:CGRectMake(65, (cell.frame.size.height-21)/2, 229, 21)];
        cell.name.font = [UIFont boldSystemFontOfSize:16];
        [cell.contentView addSubview:cell.name];
        [cell.contentView addSubview:cell.avatar];
        //cell.backgroundColor = [UIColor colorWithRed:171/255.f green:171/255.f blue:171/255.f alpha:171/255.f];
    }else
    {
        [[cell.contentView viewWithTag:10] removeFromSuperview];
    }
    cell.name.text = nil;
    cell.avatar.image = nil;
   
    if(indexPath.section == 0)
    {
       
        if(indexPath.row == 0)
        {
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.username == nil?@"未知":[CommonData sharedCommonData].curentUser.username];
            cell.avatar.image = [UIImage imageNamed:@"name"];
        }else if(indexPath.row == 1)
        {
            
            cell.avatar.image = [UIImage imageNamed:@"address.png"];
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.address==nil?@"未知":[CommonData sharedCommonData].curentUser.address];
        }else if(indexPath.row == 2)
        {
            cell.avatar.image = [UIImage imageNamed:@"old"];
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.age==nil?@"未知":[CommonData sharedCommonData].curentUser.age];
        }
    }else
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 290, cell.frame.size.height)];
        label.tag = 10;
        label.text = @"退出";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        label.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor redColor];
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
        
         KeychainItemWrapper *wapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"openfireZhao" accessGroup:nil];
        [wapper resetKeychainItem];
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
