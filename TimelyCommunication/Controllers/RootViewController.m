//
//  RootViewController.m
//  HLPChatVoewDemo
//
//  Created by zhao on 14-1-5.
//  Copyright (c) 2014年 zhao. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)action :(id)sender
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem   *spaceButton=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace     target:nil   action:nil];
	UITabBar *tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, 520, 320, 48)];
    UIBarButtonItem *chat = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chat.png"] style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    UIBarButtonItem *contact = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"contact.png"] style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    UIBarButtonItem *me = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"me.png"] style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    NSArray *items = [NSArray arrayWithObjects:chat,spaceButton,contact,spaceButton,search,spaceButton,me, nil];
    [tabBar setItems:items animated:YES];
    //toolBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:tabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
