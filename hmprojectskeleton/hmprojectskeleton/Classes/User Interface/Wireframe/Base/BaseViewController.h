//
//  BaseViewController.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 19/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import UIKit;

@interface BaseViewController : UIViewController

- (void)setupNavigationBarWithType:(NavigationBarType)barType;
- (void)leftBarButtonTouch:(id)sender;
- (void)rightBarButtonTouch:(id)sender;

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *contentView;
- (void)setupScrollView;

@property (nonatomic) UITableView *tableView;
- (void)setupTableView;

@end
