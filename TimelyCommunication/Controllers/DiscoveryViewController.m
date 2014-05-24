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
#import <Parse/Parse.h>
@interface DiscoveryViewController ()
{
    NSMutableArray *result;
    MBProgressHUD *showView;
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
    NSString *name = [CommonData sharedCommonData].curentUser.username;
   showView = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    showView.labelText = @"正在查找...";
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        PFQuery *meq = [[PFQuery alloc]initWithClassName:@"social"];
        [meq whereKey:@"username" equalTo:name];
        [meq findObjectsInBackgroundWithBlock:^(NSArray *aobjects, NSError *error) {
            PFObject *p = [aobjects firstObject];
            p[@"location"] = geoPoint;
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            [p saveEventually];
        }];
        
        PFQuery *query = [[PFQuery alloc]initWithClassName:@"social"];
        [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:5];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (PFObject *pf in objects)
            {
                NSString *people = pf[@"username"];
                if(![people isEqualToString:name])
                    [result addObject:people];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];

        }];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    result = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = [NaviItems naviLeftBtnWithImage:[UIImage imageNamed:@"near_24_24"] target:self selector:@selector(checkNearBy:)];
//    [[[SMLocationManager sharedInstance]locationManager] startUpdatingLocation];
//    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
//        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
//        username = [[username componentsSeparatedByString:@"@"] objectAtIndex:0];
//        PFQuery *query = [[PFQuery alloc]initWithClassName:@"social"];
//        [query whereKey:@"username" equalTo:username];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            PFObject *obj = [objects firstObject];
//            obj[@"location"] = geoPoint;
//            [obj saveEventually];
//            
//        }];
//    } onFailure:^(NSError *error) {
//
//    }];
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

- (User*)createUser :(PFObject*)userinfo
{
    User *user = [[User alloc]init];
    user.address = userinfo[@"address"];
    user.age = userinfo[@"age"];
    user.gender = userinfo[@"gender"];
    user.username = userinfo[@"username"];
    return user;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    showView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    showView.labelText = @"正在获取信息....";
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[result objectAtIndex:indexPath.row]];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         PFObject *pf = [objects firstObject];
         User *user = [self createUser:pf];
         PersonInfoViewController *personinfo = [[PersonInfoViewController alloc]initWithUser:user];
         personinfo.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:personinfo animated:YES];
         
    }];
}
@end
