//
//  ProductDetailViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 11/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "Product.h"
#import "PINImageView+PINRemoteImage.h"
#import "CategoryProductService.h"
#import "ShoppingCartService.h"
#import "Category.h"
#import "PriceView.h"
#import "QuantityButtonView.h"

#pragma mark - Class Extension -

@interface ProductDetailViewController () <UIPickerViewDelegate, UIPickerViewDataSource, QuantityButtonViewDelegate>

@property (nonatomic) Product *product;
@property (nonatomic) Category *category;
@property (nonatomic) CategoryProductService *cpService;
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) NSArray *pickerViewDatasource;
@property (nonatomic) NSNumber *quantity;
@property (nonatomic) UIView *shadowView;
@property (nonatomic) QuantityButtonView *quantityButton;
@property (nonatomic) ShoppingCartService *shoppingCartService;

@end

#pragma mark - Implementation -

@implementation ProductDetailViewController

- (instancetype)initWithProduct:(Product *)product {
    self = [super init];
    if (self) {
        _product = product;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _quantity = [NSNumber numberWithInt:1];
    _shoppingCartService = [ShoppingCartService new];
    
    [self loadData];
    [self setupNavigationBar];
    [self setupSubviews];
}

#pragma mark - UI

- (void)setupSubviews {
    [self setupScrollView];
    
    UIView *titleView = [self createTitleView];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:titleView];
    
    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    horizontalLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:horizontalLine];
    
    PriceView *priceView = [[PriceView alloc] initWithPrice:[NSString stringWithFormat:@"%.1f RON",_product.price]];
    priceView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:priceView];
    
    UIView *qView = [self createQuantityView];
    qView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:qView];
    
    UILabel *overviewTitle = [UILabel new];
    overviewTitle.translatesAutoresizingMaskIntoConstraints = NO;
    overviewTitle.font = [UIFont boldSystemFontOfSize:20.0];
    overviewTitle.text = @"Overview";
    [self.contentView addSubview:overviewTitle];
    
    UILabel *textView = [UILabel new];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.numberOfLines = 0;
    textView.lineBreakMode = NSLineBreakByWordWrapping;
    textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    [self.contentView addSubview:textView];
    
    UIButton *cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cartButton.translatesAutoresizingMaskIntoConstraints = NO;
    cartButton.backgroundColor = [UIColor redColor];
    [cartButton setTitle:@"Add to cart" forState:UIControlStateNormal];
    cartButton.titleLabel.textColor = [UIColor whiteColor];
    cartButton.layer.cornerRadius = 20.0;
    [cartButton addTarget:self action:@selector(cartButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cartButton];
    
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(titleView, horizontalLine, priceView, qView, overviewTitle, textView, cartButton);
    NSDictionary *metrics = @{@"titleViewHeight":@300.0,
                              @"margin":@15,
                              @"buttonMargin":@50,
                              @"qViewHeight":@80,
                              @"priceViewHeight":@80,
                              @"horizontalLineHeight":@1,
                              @"cartButtonHeight":@40};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleView(titleViewHeight)][horizontalLine(horizontalLineHeight)]-(margin)-[priceView(priceViewHeight)]-(margin)-[overviewTitle]-[textView]-(margin)-[cartButton(cartButtonHeight)]-(margin)-|" options:0 metrics:metrics views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[horizontalLine]-(margin)-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[priceView][qView(==priceView)]|" options:(NSLayoutFormatOptions)(NSLayoutFormatAlignAllBottom|NSLayoutFormatAlignAllTop) metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[overviewTitle]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[textView]-(margin)-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(buttonMargin)-[cartButton]-(buttonMargin)-|" options:0 metrics:metrics views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:cartButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (UIView *)createTitleView {
    UIView *backgroundView = [UIView new];
    
    UIImageView *productImage = [UIImageView new];
    productImage.translatesAutoresizingMaskIntoConstraints = NO;
    productImage.pin_updateWithProgress = YES;
    [productImage pin_setImageFromURL:[NSURL URLWithString:_product.imageURL]];
    [backgroundView addSubview:productImage];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    titleLabel.text = [NSString stringWithFormat:@"%@, a product you can not live without. Because it should have multiple lines.",_product.name];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:titleLabel];
    
    UILabel *categoryLabel = [UILabel new];
    categoryLabel.font = [UIFont fontWithName:categoryLabel.font.fontName size:17.0];
    categoryLabel.text = _category.name;
    categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:categoryLabel];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(productImage, titleLabel, categoryLabel);
    NSDictionary *metrics = @{@"imageDimension":@150};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[productImage(imageDimension)][titleLabel][categoryLabel]" options:0 metrics:metrics views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[productImage(imageDimension)]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[categoryLabel]-|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return backgroundView;
}

- (UIView *)createQuantityView {
    UIView *backgroundView = [UIView new];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.text = @"Quantity";
    [backgroundView addSubview:titleLabel];
    
    _quantityButton = [[QuantityButtonView alloc] init];
    _quantityButton.delegate = self;
    _quantityButton.layer.masksToBounds = YES;
    _quantityButton.layer.borderColor = [UIColor blackColor].CGColor;
    _quantityButton.layer.borderWidth = 1.0;
    _quantityButton.layer.cornerRadius = 10.0;
    _quantityButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:_quantityButton];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, _quantityButton);
    NSDictionary *metrics = @{@"margin":@15,
                              @"quantityButtonHeight":@40};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel]-(margin)-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_quantityButton]-(margin)-|" options:0 metrics:metrics views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-5-[_quantityButton(quantityButtonHeight)]" options:0 metrics:metrics views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_quantityButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0.0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return backgroundView;
}

- (void)setupNavigationBar {
    self.title = _product.name;
    [self setupNavigationBarWithType:NavigationBarTypeBack];
}

#pragma mark - Callbacks

- (void)leftBarButtonTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [_quantityButton updateQuantityWithValue:[_quantity intValue]];
    [self hidePickerView];
    [_shadowView removeFromSuperview];
}

- (void)cartButtonTouch:(UIButton *)sender {
    
    NSMutableArray *shoppingCart = [NSMutableArray arrayWithArray:[_shoppingCartService getShoppingCart]];
    for(int i=1;i<=[_quantity intValue];i++) {
        [shoppingCart addObject:[NSNumber numberWithInteger:_product.productID]];
    }
    [_shoppingCartService setShoppingCart:[NSArray arrayWithArray:shoppingCart]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"%d pieces of %@ were added.",[_quantity intValue],_product.name] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *handler) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerViewDatasource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d",[_pickerViewDatasource[row] intValue]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _quantity = _pickerViewDatasource[row];
}

#pragma mark - QuantityButtonViewDelegate

- (void)didPressQuantityButton {
    [self showPickerView];
}

#pragma mark - Helper methods

- (void)loadData {
    _pickerViewDatasource = @[@1,@2,@3,@4,@5];
    
    __weak typeof(self) weakSelf = self;
    _cpService = [CategoryProductService new];
    [_cpService loadCategoryForProduct:_product withSuccess:^(Category *result) {
        weakSelf.category = result;
    } andError:^{
        NSLog(@"No category found for this product.");
    }];
}

- (void)showPickerView {
    _shadowView = [[UIView alloc] initWithFrame:self.view.frame];
    _shadowView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_shadowView];
    [_shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 150.0)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.pickerView.frame = CGRectMake(0, strongSelf.view.frame.size.height - 150, strongSelf.view.frame.size.width, 150.0);
    }];
}

- (void)hidePickerView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.pickerView.frame = CGRectMake(0, strongSelf.view.frame.size.height, strongSelf.view.frame.size.width, 150.0);
    } completion:^(BOOL finished) {
        [weakSelf.shadowView removeFromSuperview];
    }];
}

@end
