//
//  NewFriendViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-8.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "NewFriendViewController.h"
#import "SimpleCell.h"
#import "SMClient.h"
#import "SMQuery.h"
#import "CommonData.h"
#import "MBProgressHUD.h"
#import "Config.h"
#import "iPhoneXMPPAppDelegate.h"
#import "Conversation.h"
#define kColor 200/255.f
@interface NewFriendViewController ()
{
    NSMutableArray *addmes;
}
@end

@implementation NewFriendViewController

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
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:[CommonData sharedCommonData].curentUser.username];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        if(results.count > 0)
        {
            NSDictionary *info = [results objectAtIndex:0];
            NSArray *addme = [info objectForKey:@"addme"];
            addmes = [NSMutableArray arrayWithArray:addme];
            [self.tableView reloadData];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数据请求发生错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addmes.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)display :(SimpleCell*)cell
{
    [cell.operation removeFromSuperview];
    [cell.info removeFromSuperview];
    [cell.avatar removeFromSuperview];
    [cell.contentView addSubview:cell.operation];
    [cell.contentView addSubview:cell.info];
    [cell.contentView addSubview:cell.avatar];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        cell.info = [[UILabel alloc]initWithFrame:CGRectMake(70, 19, 181, 22)];
        cell.info.font = [UIFont systemFontOfSize:15.f];
        cell.info.textColor = [UIColor colorWithRed:kColor green:kColor blue:kColor alpha:1.f];
        cell.operation = [UIButton buttonWithType:UIButtonTypeContactAdd];
        cell.operation.frame = CGRectMake(280, 19, 22, 22);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, cell.frame.size.width, 1)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
        
    }
    cell.operation.tag = indexPath.row;
    cell.avatar.image = [UIImage imageNamed:@"avatar.png"];
    cell.info.text = [[addmes objectAtIndex:indexPath.row] stringByAppendingString:@"  请求加你为好友"];
    [self display:cell];
    [cell.operation addTarget:self action:@selector(agreenAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    return cell;
}
- (BOOL)isFriendExist :(NSString*)friend :(NSArray*)friends
{
    for (NSString *unmae in friends)
    {
        if([unmae isEqualToString:friend])
        {
            return YES;
        }
    }
    return NO;
}
- (void)agreenAction :(UIButton*)sender;
{
    int tag = sender.tag;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *username = [addmes objectAtIndex:tag];
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:[CommonData sharedCommonData].curentUser.username];
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        if(results.count > 0)
        {
            NSDictionary *info = [results objectAtIndex:0];
            NSArray *friends = [info objectForKey:@"friends"];
            NSMutableArray *apply = [NSMutableArray arrayWithArray:[info objectForKey:@"addme"]];
            [apply removeObject:username];
            NSMutableArray *newFriends = [NSMutableArray arrayWithArray:friends];
            if(![self isFriendExist:username :newFriends])
               [newFriends addObject:username];
            NSDictionary *update = [NSDictionary dictionaryWithObjectsAndKeys:newFriends,@"friends",apply,@"addme", nil];
            
            //更新当前用户的 friend列表和申请列表
            [[[SMClient defaultClient] dataStore] updateObjectWithId:[CommonData sharedCommonData].curentUser.username inSchema:@"user" update:update onSuccess:^(NSDictionary *object, NSString *schema) {
                
                [addmes removeObject:username];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:username];
            //更新申请者的friend列表
                SMQuery *queryN = [[SMQuery alloc]initWithSchema:@"user"];
                [query where:@"username" isEqualTo:username];
                [[[SMClient defaultClient] dataStore] performQuery:queryN onSuccess:^(NSArray *results) {
                    if(results.count > 0)
                    {
                        NSDictionary *uinfo = [results objectAtIndex:0];
                        NSMutableArray *unewfriends = [NSMutableArray arrayWithArray:[uinfo objectForKey:@"friends"]];
                        [unewfriends addObject:[CommonData sharedCommonData].curentUser.username];
                        
                        
                        NSDictionary *nupdate = [NSDictionary dictionaryWithObjectsAndKeys:unewfriends,@"friends", nil];
                        [[[SMClient defaultClient] dataStore] updateObjectWithId:username inSchema:@"user" update:nupdate onSuccess:^(NSDictionary *object, NSString *schema) {
                            [[Conversation sharedInstance] pushAgreen:username];
                            
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                        } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        }];
                        
                    }
                } onFailure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }];

        }
    } onFailure:^(NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
    
    
    
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */
- (void)dealloc
{
    NSLog(@"NewFriendViewController dealloc");
}
@end
