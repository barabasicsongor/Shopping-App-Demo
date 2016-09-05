//
//  RootTableViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "RootViewController.h"
#import "ShopDetailViewController.h"
#import "ShopTableViewCell.h"
#import "ShopService.h"
#import "LocationService.h"
#import "Shop.h"
#import "HMPAppearance.h"
#import "RESideMenu.h"

static NSString * const kTableViewCellIdentifier = @"cell";

#pragma mark - Class extension -

@interface RootViewController () <UISearchBarDelegate, ShopTableViewCellDelegate, LocationServiceDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray<Shop *> *shops;
@property (nonatomic) NSArray<Shop *> *searchResult;
@property (nonatomic) BOOL isSearch;
@property (nonatomic) ShopService *shopService;
@property (nonatomic) LocationService *locationService;

@end

#pragma mark - Implementation -

@implementation RootViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackgroundMain;
    
    [self loadData];
    [self tableViewSetup];
    [self setupSearchBar];
    [self setupNavigationBar];
    [self getUserLocation];
}

#pragma mark - UI

/**
 *  Set up table view.
 */
- (void)tableViewSetup {
    [self setupTableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ShopTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.tableView setRowHeight:55.0];
}

/**
 *  Set up search bar and put it into table view header.
 */
- (void)setupSearchBar {
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
    searchBar.placeholder = @"Search";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

/**
 *  Set up navigation bar with custom back button.
 */
- (void)setupNavigationBar {
    self.title = @"List of shops";
    [self setupNavigationBarWithType:NavigationBarTypeSideMenu];
}

#pragma mark - Callbacks

- (void)leftBarButtonTouch:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - TableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return _searchResult.count;
    } else {
        return _shops.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    
    Shop *shop;
    if (_isSearch) {
        shop = _searchResult[indexPath.row];
    } else {
        shop = _shops[indexPath.row];
    }
    [cell setShop:shop];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Shop *shop;
    if (_isSearch) {
        shop = _searchResult[indexPath.row];
    } else {
        shop = _shops[indexPath.row];
    }
    
    ShopDetailViewController *vc = [[ShopDetailViewController alloc] initWithShop:shop];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ShopTableViewCellDelegate

- (void)didPressFavouriteButtonForShop:(Shop *)shop {
    shop.favouriteState = !shop.favouriteState;
    [self.tableView reloadData];
    [_shopService updateFavouriteStateOfShop:shop];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        _isSearch = NO;
        [self.tableView reloadData];
    } else {
        _isSearch = YES;
        
        __weak typeof(self) weakSelf = self;
        [_shopService filterShopsAccordingToString:searchText fromArray:_shops withCompletionHandler:^(NSArray *result) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.searchResult = result;
            [strongSelf.tableView reloadData];
        }];
    }
}

#pragma mark - LocationServiceDelegate

- (void)didFinishGettingUsersLocation {
    [_locationService calculateDistanceFromUserToShops:_shops];
}

- (void)didFinishRouteDistanceCalculation {
    [self.tableView reloadData];
}

#pragma mark - Helper methods

/**
 *  Load shops from database through shop service.
 */
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    _shopService = [ShopService new];
    [_shopService loadShopsWithCompletionHandler:^(NSArray *shops) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.shops = shops;
        [strongSelf.tableView reloadData];
    }];
}

/**
 *  Get users current location.
 */
- (void)getUserLocation {
    _locationService = [LocationService new];
    _locationService.delegate = self;
    [_locationService getUserLocation];
}

@end
