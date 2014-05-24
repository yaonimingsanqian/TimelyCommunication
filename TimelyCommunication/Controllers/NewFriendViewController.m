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
#import <Parse/Parse.h>
#define kColor 200/255.f

static int addTime = 0;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *pfQuery =[[PFQuery alloc]initWithClassName:@"social"];
    [pfQuery whereKey:@"username" equalTo:[CommonData sharedCommonData].curentUser.username];
    [pfQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *info = [objects objectAtIndex:0];
         NSArray *addme = info[@"addme"];
        addmes = [NSMutableArray arrayWithArray:addme];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFrieFailed:) name:kFriendAddFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriendSuccess:) name:kFriendAddFinished object:nil];
    self.tableView.separatorColor = [UIColor whiteColor];
}
- (void)addFriendSuccess :(NSNotification*)noti
{
    NSString *username = [noti object];
    
     NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewFriend,kRefreshtype,username,kMsgFrom, nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:kRefeshcontact object:info];
    addTime = 0;
    [[Conversation sharedInstance] pushAgreen:username];
    [addmes removeObject:username];
    [self.tableView reloadData];
}
- (void)addFrieFailed :(NSNotification*)noti
{
    if(addTime <= 10)
    {
        NSString *name = [noti object];
        [self updateApplierFriendList:name];
        addTime++;
    }
   
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
- (void)updateApplierFriendList :(NSString*)username
{
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:username];
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        if(results.count > 0)
        {
            NSDictionary *uinfo = [results objectAtIndex:0];
            NSMutableArray *unewfriends = [NSMutableArray arrayWithArray:[uinfo objectForKey:@"friends"]];
            [unewfriends addObject:[CommonData sharedCommonData].curentUser.username];
            
            
            NSDictionary *nupdate = [NSDictionary dictionaryWithObjectsAndKeys:unewfriends,@"friends", nil];
            [[[SMClient defaultClient] dataStore] updateObjectWithId:username inSchema:@"user" update:nupdate onSuccess:^(NSDictionary *object, NSString *schema) {
                
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              //  NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:kNewFriend,kRefreshtype,username,kMsgFrom, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFriendAddFinished object:username];
                
            } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kFriendAddFailed object:username];
            }];
            
        }
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)agreenAction :(UIButton*)sender;
{
    int tag = sender.tag;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *username = [addmes objectAtIndex:tag];
    
    PFQuery *pfquery = [[PFQuery alloc]initWithClassName:@"social"];
    [pfquery whereKey:@"username" equalTo:[CommonData sharedCommonData].curentUser.username];
    
    [pfquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *info = [objects objectAtIndex:0];
        NSArray *friends = info[@"friends"];
        NSMutableArray *apply = info[@"addme"];
        [apply removeObject:username];
         NSMutableArray *newFriends = [NSMutableArray arrayWithArray:friends];
        if(![self isFriendExist:username :newFriends])
            [newFriends addObject:username];
        info[@"friends"] = newFriends;
        info[@"addme"] = apply;
        [info saveEventually];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFriendAddFinished object:username];
    }];
    
    //更新对方的朋友列表，这目前来说不太合理
    
    PFQuery *query = [[PFQuery alloc]initWithClassName:@"social"];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *info = [objects objectAtIndex:0];
        NSArray *friends = info[@"friends"];
        NSMutableArray *newFriends = [NSMutableArray arrayWithArray:friends];
        if(![self isFriendExist:[CommonData sharedCommonData].curentUser.username :newFriends])
            [newFriends addObject:[CommonData sharedCommonData].curentUser.username];
        info[@"friends"] = newFriends;
        [info saveEventually];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFriendAddFinished object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFriendAddFailed object:nil];
    NSLog(@"NewFriendViewController dealloc");
}
@end
