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

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToSearchBarConstraint;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.images) {
        self.images = [NSArray new];
    }

    if (!self.posts) {
        self.posts = [NSArray new];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];

    self.searchBar.barTintColor = [PMColor lightBlackColor];

    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *images, NSError *error) {
        if (!error) {
//            for (PFObject *image in images) {
//                self.imageDictionary = @{
//                                         image.objectId: image[@"file"]
//                                         };
//            }
            self.images = images;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];

    [self.parseDataHandler queryPosts];
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
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
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
    
//    CGRect tableViewRect = self.tableView.frame;
//    tableViewRect.origin.y = MIN(108.0f, -scrollView.contentOffset.y + 108.0f);
//    self.topToSearchBarConstraint.constant -= scrollView.contentOffset.y;
//    self.tableView.frame = tableViewRect;
//    CGFloat scrollViewContainerHeight = 44.0f;
//    CGFloat scrollViewContainerOffset = -MAX(MIN(scrollViewContainerHeight, scrollView.contentOffset.y), 0.0f);
//    self.topToSearchBarConstraint.constant = scrollViewContainerOffset;
//    NSLog(@"%f", scrollView.contentOffset.y);
//    NSLog(@"%f", scrollViewContainerOffset);
//    NSLog(@"%f", self.topToSearchBarConstraint.constant);

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
    cell.rightIV.image = [UIImage imageNamed:@"male28.png"];



    if (self.images.count) {
        PFQuery *query = [PFQuery queryWithClassName:@"Image"];
        [query whereKey:@"parent" equalTo:[[self.posts objectAtIndex:indexPath.row] objectForKey:@"parent"]];
        PFFile *imageFile = [[self.images objectAtIndex:0] objectForKey:@"file"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            cell.rightIV.image = [UIImage imageWithData:data];
        }];
    }

    return cell;
}

- (IBAction)onLeftBarButtonSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
