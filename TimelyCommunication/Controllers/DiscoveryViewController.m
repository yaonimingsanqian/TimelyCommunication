//
//  DiscoveryViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-4-19.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "SMLocationManager.h"
#import "SMGeoPoint.h"
#import "SMQuery.h"
#import "Config.h"
#import "CommonData.h"
#import "MBProgressHUD.h"
#import "ContactCell.h"
#import "PersonInfoViewController.h"
@interface DiscoveryViewController ()
{
    NSMutableArray *result;
}
@end

@implementation DiscoveryViewController

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
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"发现"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
    
}
- (void)checkNearBy :(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
        SMQuery *query = [[SMQuery alloc]initWithSchema:@"location"];
        [query where:@"coordinate" isWithin:5 milesOfGeoPoint:geoPoint];
        [[[SMClient defaultClient]dataStore] performQuery:query onSuccess:^(NSArray *results) {
            [result removeAllObjects];
           NSString *name = [CommonData sharedCommonData].curentUser.username;
            for (NSDictionary *point in results)
            {
                NSString *people = [point objectForKey:@"username"];
                if(![people isEqualToString:name])
                   [result addObject:people];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        }];
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    result = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = [NaviItems naviLeftBtnWithImage:[UIImage imageNamed:@"near_24_24"] target:self selector:@selector(checkNearBy:)];
    [[[SMLocationManager sharedInstance]locationManager] startUpdatingLocation];
    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
        username = [[username componentsSeparatedByString:@"@"] objectAtIndex:0];
        SMQuery *query = [[SMQuery alloc]initWithSchema:@"location"];
        [query where:@"username" isEqualTo:username];
        [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
            if(results.count <= 0)
            {
                  //NSDictionary *updatedTodo = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username",geoPoint,"coordinate", nil];
                NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
                [insertDic setValue:username forKey:@"username"];
                [insertDic setValue:geoPoint forKey:@"coordinate"];
                
                [[[SMClient defaultClient] dataStore] createObject:insertDic inSchema:@"location" onSuccess:^(NSDictionary *object, NSString *schema) {
                    TCLog(@"定位成功");
                } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {

                }];
            }else
            {
                NSDictionary *info = [results objectAtIndex:0];
                
                NSMutableDictionary *insertDic = [[NSMutableDictionary alloc]init];
                [insertDic setValue:username forKey:@"username"];
                [insertDic setValue:geoPoint forKey:@"coordinate"];
                [[[SMClient defaultClient] dataStore] updateObjectWithId:[info objectForKey:@"location_id"] inSchema:@"location" update:insertDic onSuccess:^(NSDictionary *object, NSString *schema) {
                    
                    NSLog(@"等位成功更新成功");
                   
                } onFailure:^(NSError *error, NSDictionary *object, NSString *schema) {
                    NSLog(@"定位成功，更新失败");
                }];
                
            }
        } onFailure:^(NSError *error) {

        }];
    } onFailure:^(NSError *error) {

    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
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
    return result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"iden";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(!cell)
    {
        cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
       
        cell.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        cell.name = [[UILabel alloc]initWithFrame:CGRectMake(77, 17, 229, 21)];
        cell.name.font = [UIFont systemFontOfSize:15.f];
        [cell.contentView addSubview:cell.avatar];
        [cell.contentView addSubview:cell.name];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
    }
    CGRect frame = cell.frame;
    frame.size.height = 60;
    cell.frame = frame;
    cell.avatar.frame = CGRectMake(15, 3, 40, 40);
    cell.avatar.image = [UIImage imageNamed:@"mainPage.png"];
    cell.name.text = [result objectAtIndex:indexPath.row];
    
    return cell;
}

- (User*)createUser :(NSDictionary*)userinfo
{
    User *user = [[User alloc]init];
    user.address = [userinfo objectForKey:@"address"];
    user.age = [userinfo objectForKey:@"age"];
    user.gender = [userinfo objectForKey:@"gender"];
    user.username = [userinfo objectForKey:@"username"];
    return user;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    UITextField *search = (UITextField*)[self.view viewWithTag:101];
    NSString *current = [[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID] lowercaseString];
    if([[search.text lowercaseString] isEqualToString:current])
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能搜索自己" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil ];
        [alert show];
        return;
    }
    [query where:@"username" isEqualTo:[result objectAtIndex:indexPath.row]];
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(results.count > 0)
        {
            User *user = [self createUser:[results objectAtIndex:0]];
            PersonInfoViewController *personinfo = [[PersonInfoViewController alloc]initWithUser:user];
            personinfo.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personinfo animated:YES];
            
        }
        
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
@end
