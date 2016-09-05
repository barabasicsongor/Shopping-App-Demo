//
//  ShopDetailViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import MapKit;
#import "ShopDetailViewController.h"
#import "ProductDetailViewController.h"
#import "ProductTableViewCell.h"
#import "CategoryProductService.h"
#import "Shop.h"
#import "ShopCategories.h"
#import "HMPAppearance.h"

static NSString * const kTableViewCellIdentifier = @"cell";

#pragma mark - Class Extension -

@interface ShopDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) Shop *shop;
@property (nonatomic) NSArray<ShopCategories *> *shopCategories;
@property (nonatomic) MKMapView *mapView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) CategoryProductService *cpService;

@end

#pragma mark - Implementation -

@implementation ShopDetailViewController

#pragma mark - Lifecycle

- (instancetype)initWithShop:(Shop *)shop {
    self = [super init];
    if (self) {
        _shop = shop;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackgroundMain;
    
    [self loadData];
    [self setupNavigationBar];
    [self setupMap];
    [self setupTableView];
}

#pragma mark - UI

/**
 *  Set up the map, show users location, set zoom region, add annotation for the current shop.
 */
- (void)setupMap {
    _mapView = [MKMapView new];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    NSMutableArray *constraints = [NSMutableArray new];
    id topLayoutGuide = (UIView *)self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(_mapView, topLayoutGuide);
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:200.0]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_mapView]" options:0 metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:constraints];
    
    //Set zoom region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(_shop.latitude, _shop.longitude), 805, 805);
    [_mapView setRegion:viewRegion];
    
    //Add annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(_shop.latitude, _shop.longitude);
    point.title = _shop.name;
    [_mapView addAnnotation:point];
}

/**
 *  Set up navigation bar.
 */
- (void)setupNavigationBar {
    self.title = _shop.name;
    [self setupNavigationBarWithType:NavigationBarTypeBack];
}

/**
 *  Set up tableview which displays the products available in the current shop. Register custom tableview cell.
 */
- (void)setupTableView {
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[ProductTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.tableView setSectionHeaderHeight:30.0];
    [self.view addSubview:self.tableView];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = @{@"map":self.mapView,
                            @"tableView":self.tableView};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[map][tableView]|" options:0 metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

/**
 *  Back button press. Pops the view controller.
 *
 *  @param sender UIButton
 */
- (void)leftBarButtonTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shopCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopCategories[section].products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    
    [cell setProduct:_shopCategories[indexPath.section].products[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithProduct:_shopCategories[indexPath.section].products[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30.0)];
    bgView.backgroundColor = [UIColor blackColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-15.0, 30.0)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [bgView addSubview:titleLabel];
    
    titleLabel.text = _shopCategories[section].name;
    
    return bgView;
}

#pragma mark - Helper Methods

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    _cpService = [CategoryProductService new];
    [_cpService loadProductsForShop:_shop withCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.shopCategories = result;
        [strongSelf.tableView reloadData];
    }];
}

@end
