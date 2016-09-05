//
//  ProductListTableViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductTableViewCell.h"
#import "CategoryProductService.h"
#import "Category.h"
#import "Product.h"
#import "ShopCategories.h"

#pragma mark - Class Extension -

@interface ProductListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray<ShopCategories *> *dataSource;
@property (nonatomic) NSMutableArray<Product *> *selection;
@property (nonatomic) CategoryProductService *cpService;

@end

#pragma mark - Implementation

@implementation ProductListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setupNavigationBar];
    [self tableViewSetup];
}

#pragma mark - UI

- (void)tableViewSetup {
    [self setupTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ProductTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView setSectionHeaderHeight:30.0];
}

- (void)setupNavigationBar {
    self.title = @"Products";
    [self setupNavigationBarWithType:NavigationBarTypeBackAdd];
}

#pragma mark - Callbacks

/**
 *  Called on back button press. Pops view controller.
 *
 *  @param sender UIButton
 */
- (void)leftBarButtonTouch:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Add button pressed. It calls the delegate method with the array of selected products, and then pops the view controller.
 *
 *  @param sender UIBarButtonItem
 */
- (void)rightBarButtonTouch:(UIButton *)sender {
    [self.delegate didFinishSelectingProducts:[NSArray arrayWithArray:_selection]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource[section].products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setProduct:_dataSource[indexPath.section].products[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Product *product = _dataSource[indexPath.section].products[indexPath.row];
    
    if ([_selection containsObject:product]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selection removeObject:product];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selection addObject:product];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30.0)];
    bgView.backgroundColor = [UIColor blackColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15, 30.0)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [bgView addSubview:titleLabel];
    
    titleLabel.text = _dataSource[section].name;
    
    return bgView;
}

#pragma mark - Helper methods

/**
 *  Load data from database through services.
 *  Load all categories.
 *  Load all products.
 *  Sort products into categories and init selection array.
 *  Reload tableview.
 */
- (void)loadData {
    _selection = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    _cpService = [CategoryProductService new];
    [_cpService loadProductsSortedIntoCategoriesWithCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.dataSource = result;
        [strongSelf.tableView reloadData];
    }];
}

@end
