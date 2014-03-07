//
//  SearchFriendViewController.m
//  TimelyCommunication
//
//  Created by zhao on 14-3-4.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "SMQuery.h"
#import "SMClient.h"
#import "MBProgressHUD.h"
#import "User.h"

#import "PersonInfoViewController.h"

@interface SearchFriendViewController ()

@end

@implementation SearchFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(20, 120, 280, 40)];
    searchField.tag = 101;
    searchField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:searchField];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(20, 170, 280, 40);
    searchBtn.backgroundColor = [UIColor greenColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
- (void)tap
{
    UITextField *search = (UITextField*)[self.view viewWithTag:101];
    [search resignFirstResponder];
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
- (void)search
{
    [self tap];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
     UITextField *search = (UITextField*)[self.view viewWithTag:101];
    [query where:@"username" isEqualTo:search.text];
    SearchFriendViewController __weak *tmp = self;
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(results.count > 0)
        {
            User *user = [tmp createUser:[results objectAtIndex:0]];
            PersonInfoViewController *personinfo = [[PersonInfoViewController alloc]initWithUser:user];
            personinfo.hidesBottomBarWhenPushed = YES;
            [tmp.navigationController pushViewController:personinfo animated:YES];
            
        }
        
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"SearchFriendViewController dealloc");
}
@end
