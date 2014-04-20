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


@interface DiscoveryViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                    NSLog(@"定位成功");
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
    [SMGeoPoint getGeoPointForCurrentLocationOnSuccess:^(SMGeoPoint *geoPoint) {
        SMQuery *query = [[SMQuery alloc]initWithSchema:@"location"];
        [query where:@"coordinate" isWithin:5 milesOfGeoPoint:geoPoint];
        [[[SMClient defaultClient]dataStore] performQuery:query onSuccess:^(NSArray *results) {
            for (NSDictionary *point in results)
            {
                NSLog(@"%@",[point objectForKey:@"username"]);
            }
        } onFailure:^(NSError *error) {
            NSLog(@"定位失败");
        }];
    } onFailure:^(NSError *error) {
        NSLog(@"定位失败--");
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
