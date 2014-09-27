//
//  ListViewController.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/16/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "ListTableViewCell.h"
#import "ListViewController.h"
#import "PMColor.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];

    self.searchBar.barTintColor = [PMColor lightBlackColor];
    [self.parseDataHandler queryPosts];
    self.posts = [NSArray new];
    self.posts = self.parseDataHandler.posts;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"pins9.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onLeftBarButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 14, 22.2)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    for (int i = 0; i < 8; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGRect cellFrame = cell.frame;
        cellFrame.origin.x -= cellFrame.size.width;
        cell.frame = cellFrame;

        [UIView animateWithDuration:0.3
                              delay:i*0.12+0.2
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.05
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                                CGRect cellFrame = cell.frame;
                                cellFrame.origin.x += cellFrame.size.width;
                                cell.frame = cellFrame;
                            } completion:nil];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect searchBarRect = self.searchBar.frame;
    searchBarRect.origin.y = MAX(20.0f, -scrollView.contentOffset.y + 64.0f);
    self.searchBar.frame = searchBarRect;

    CGRect tableViewRect = self.tableView.frame;
    tableViewRect.origin.y = MIN(108.0f, -scrollView.contentOffset.y + 108.0f);
    self.tableViewHeightConstraint.constant += scrollView.contentOffset.y;
    self.tableView.frame = tableViewRect;
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
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];

    PFObject *post = [self.posts objectAtIndex:indexPath.row];

    cell.textLabel.text = [post objectForKey:@"title"];
    cell.detailTextLabel.text = [post objectForKey:@"subtitle"];

    return cell;
}

- (IBAction)onLeftBarButtonSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
