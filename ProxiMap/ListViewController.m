//
//  ListViewController.m
//  ProxiMap
//
//  Created by Dan Hogan on 9/16/14.
//  Copyright (c) 2014 Dan Hogan. All rights reserved.
//

#import "ListViewController.h"
#import "PMColor.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];

    self.searchBar.barTintColor = [PMColor lightBlueColor];
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

        [UIView animateWithDuration:0.4
                              delay:i*0.12+0.2
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.05
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                                CGRect cellFrame = cell.frame;
                                cellFrame.origin.x += cellFrame.size.width;
                                cell.frame = cellFrame;
                            } completion:^(BOOL finished) {

                            }];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rect = self.searchBar.frame;
    rect.origin.y = MAX(20.0f, -scrollView.contentOffset.y + 64.0f);
    self.searchBar.frame = rect;

    CGRect rect2 = self.tableView.frame;
    rect2.origin.y = MIN(108.0f, -scrollView.contentOffset.y + 108.0f);
    self.tableView.frame = rect2;

//    CGPoint contentOffset = self.tableView.contentOffset;
//    NSLog(@"CO:%f", contentOffset.y);
//    NSLog(@"Tableview CO:%f", self.tableView.contentOffset.y);

    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.

//    if (contentOffset.y > 0) {
//        contentOffset.y += 44;
//        self.tableView.contentOffset = contentOffset;
//    }
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
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:24.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [post objectForKey:@"title"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next" size:16.0];
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
