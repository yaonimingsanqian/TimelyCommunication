//
//  FKRSearchBarTableViewController.m
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRSearchBarTableViewController.h"
#import "SMClient.h"
#import "SMQuery.h"

static NSString * const kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier = @"kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier";

@interface FKRSearchBarTableViewController () {
    NSString *conuuid;
}

@property(nonatomic, copy) NSMutableArray *famousPersons;
@property(nonatomic, strong) NSMutableArray *filteredPersons;
@property(nonatomic, copy) NSArray *sections;

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, strong, readwrite) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController; // UIViewController doesn't retain the search display controller if it's created programmatically: http://openradar.appspot.com/10254897

@end

@implementation FKRSearchBarTableViewController

#pragma mark - Initializer

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes :(NSString*)conId
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        UILabel *title = (UILabel*)[self.navigationController.view viewWithTag:100];
        title.text = @"添加好友";
        
        _showSectionIndexes = showSectionIndexes;
        conuuid = conId;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    //[self.searchBar becomeFirstResponder];
    
    [self.searchBar sizeToFit];
    for(UIView *sub in [self.searchBar subviews])
    {
        if([sub isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)sub;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }

    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (animated) {
        [self.tableView flashScrollIndicators];
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    NSAssert(YES, @"This method should be handled by a subclass!");
}

#pragma mark - TableView Delegate and DataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView && self.showSectionIndexes) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView && self.showSectionIndexes) {
        if ([[self.sections objectAtIndex:section] count] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFKRSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    }
    cell.textLabel.text = self.user.username;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
#pragma mark - Search Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SMQuery *query = [[SMQuery alloc]initWithSchema:@"user"];
    [query where:@"username" isEqualTo:searchBar.text];
    FKRSearchBarTableViewController __weak *tmp = self;
    [[[SMClient defaultClient] dataStore] performQuery:query onSuccess:^(NSArray *results) {
        if(results.count > 0)
        {
            tmp.user = [tmp createUser:[results objectAtIndex:0]];
            [tmp.tableView reloadData];
            [tmp.searchBar resignFirstResponder];
            
            
        }
       
    } onFailure:^(NSError *error) {
        
    }];
}
@end