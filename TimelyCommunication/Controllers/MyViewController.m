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
#import <Parse/Parse.h>
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
        return 4;
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0)
        return 80;
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1) return 80;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  static *reuseIdentifier = @"reuseIdentifier";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(!cell)
    {
        cell = [[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        int rowHeight = cell.frame.size.height;
        if(indexPath.section == 0 && indexPath.row == 0)
            rowHeight = 80;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(18, rowHeight-0.5, 320, 0.5)];
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
       
        if(indexPath.row == 1)
        {
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.username == nil?@"未知":[CommonData sharedCommonData].curentUser.username];
            cell.avatar.image = [UIImage imageNamed:@"name"];
        }else if(indexPath.row == 2)
        {
            
            cell.avatar.image = [UIImage imageNamed:@"address.png"];
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.address==nil?@"未知":[CommonData sharedCommonData].curentUser.address];
        }else if(indexPath.row == 3)
        {
            cell.avatar.image = [UIImage imageNamed:@"old"];
            cell.name.text = [NSString stringWithFormat:@"%@",[CommonData sharedCommonData].curentUser.age==nil?@"未知":[CommonData sharedCommonData].curentUser.age];
        }else
        {
            cell.avatar.frame = CGRectMake(18, (80-60)/2, 60, 60);
            PFUser *user = [PFUser currentUser];
            PFFile *userImageFile = user[@"avatar"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    cell.avatar.image = image;
                }
            }];
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
    
    [PFUser logOut];
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"您退出后将清楚密码，但是历史数据会保存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [sheet showInView:self.tableView];
    }
    if(indexPath.row == 0 && indexPath.section == 0)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        sheet.tag = 1011;
        [sheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1011)
    {
        if(buttonIndex == 0)
        {
            [self takePhoto];
        }else if(buttonIndex == 1)
        {
            [self localPhoto];
        }
        return;
    }
    if(buttonIndex == 0)
    {
        [self logout:nil];
    }
}
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}
-(void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - imagepickerdelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    waiting = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waiting.labelText = @"正在处理...";
    NSData *imageData = UIImageJPEGRepresentation(image,1.f);
    PFFile *imageFile = [PFFile fileWithName:@"avatar.jpg" data:imageData];
    PFUser *user = [PFUser currentUser];
    user[@"avatar"] = imageFile;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        ContactCell *cell = (ContactCell*)[self.tableView cellForRowAtIndexPath:indexpath];
        cell.avatar.image = image;
        
    }];
}
- (void)dealloc
{
}

@end
