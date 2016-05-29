//
//  MenuResultsController.m
//  XCFDemo
//
//  Created by Durian on 5/3/16.
//  Copyright © 2016 durian. All rights reserved.
//

#import "MenuResultsController.h"

@interface MenuResultsController ()

@end

@implementation MenuResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setNavBar];
}

- (void)setNavBar
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backStretchBackgroundNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousPage)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(beginSearch)];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜索菜单";
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.titleView = searchBar;
}

- (void)backToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beginSearch
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
@end
