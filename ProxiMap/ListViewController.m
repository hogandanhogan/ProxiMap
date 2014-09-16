//
//  ListViewController.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/16/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *users;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

@end
