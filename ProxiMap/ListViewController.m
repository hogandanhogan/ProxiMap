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
@property NSArray *posts;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];

    self.posts = [NSArray arrayWithObjects:@"Hi", @"How are you", @"Have a nice day", nil];

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //[query orderByAscending:<#(NSString *)#>]

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-heavy" size:24.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [self.posts objectAtIndex:indexPath.row];

    return cell;
}

@end
