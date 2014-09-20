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
@property (nonatomic) NSArray *posts;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];

    [self.parseDataHandler queryPosts];
    self.posts = [NSArray new];
    self.posts = self.parseDataHandler.posts;

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"pins9.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLeftBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 16 , 24.2)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}

- (void)viewWillAppear:(BOOL)animated
{

    [self.tableView reloadData];
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

    PFObject *post = [self.posts objectAtIndex:indexPath.row];

    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-heavy" size:24.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [post objectForKey:@"title"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir-heavy" size:16.0];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [post objectForKey:@"title"];
    cell.detailTextLabel.text = [post objectForKey:@"subtitle"];

    return cell;
}

- (IBAction)onLeftBarButtonSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
