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
#import "NavigationControllerTitle.h"
#import "PersonInfoViewController.h"
#import "Config.h"
@interface SearchFriendViewController ()
{
    MBProgressHUD *mb;
}
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NavigationControllerTitle showInView:self.navigationController.navigationBar :@"搜索"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NavigationControllerTitle hide:self.navigationController.navigationBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f];
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(20, 94, 280, 40)];
    searchField.placeholder = @"请输入对方的ID";
    searchField.tag = 101;
    searchField.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:searchField];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(20, 144, 280, 40);
    searchBtn.backgroundColor = [UIColor colorWithRed:53/255.f green:99/255.f blue:25/255.f alpha:1.f];
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
   mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mb.labelText = @"正在搜索..";
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
     UITextField *search = (UITextField*)[self.view viewWithTag:101];
    NSString *current = [[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID] lowercaseString];
    if([[search.text lowercaseString] isEqualToString:[[current componentsSeparatedByString:@"@"] objectAtIndex:0]])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能搜索自己" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil ];
        [alert show];
        return;
    }
    [query where:@"username" isEqualTo:[search.text lowercaseString]];
    SearchFriendViewController __weak *tmp = self;
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(results.count > 0)
        {
            User *user = [tmp createUser:[results objectAtIndex:0]];
            PersonInfoViewController *personinfo = [[PersonInfoViewController alloc]initWithUser:user];
            personinfo.hidesBottomBarWhenPushed = YES;
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            self.navigationItem.backBarButtonItem = backItem;
            backItem.title = @"返回";
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
