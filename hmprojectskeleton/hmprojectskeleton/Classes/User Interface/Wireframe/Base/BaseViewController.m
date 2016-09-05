//
//  BaseViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 19/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "BaseViewController.h"

#pragma mark - Class Extension -

@interface BaseViewController ()

@end

#pragma mark - Implementation -

@implementation BaseViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Public methods

- (void)setupNavigationBarWithType:(NavigationBarType)barType {
    switch (barType) {
        case NavigationBarTypeBack:
            [self setupNavigationBarForTypeBack];
            break;
        case NavigationBarTypeBackAdd:
            [self setupNavigationBarForTypeBackAdd];
            break;
        case NavigationBarTypeSideMenu:
            [self setupNavigationBarForTypeSideMenu];
            break;
        case NavigationBarTypeResetEdit:
            [self setupNavigationBarForTypeResetEdit];
            break;
        default:
            break;
    }
}

- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [UIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contentView];
    
    id topLayoutGuide = (UIView *)self.topLayoutGuide;
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(topLayoutGuide, _scrollView, _contentView);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_scrollView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView(==_scrollView)]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView(>=_scrollView)]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [UITableView new];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    id topLayoutGuide = (UIView *)self.topLayoutGuide;
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView, topLayoutGuide);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_tableView]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

- (void)leftBarButtonTouch:(id)sender {
}

- (void)rightBarButtonTouch:(UIButton *)sender {
    
}

#pragma mark - UI helpers

- (void)setupNavigationBarForTypeBack {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 40);
    [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)setupNavigationBarForTypeResetEdit {
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTouch:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setupNavigationBarForTypeBackAdd {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 40);
    [leftButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTouch:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)setupNavigationBarForTypeSideMenu {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"sidemenu_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

@end
