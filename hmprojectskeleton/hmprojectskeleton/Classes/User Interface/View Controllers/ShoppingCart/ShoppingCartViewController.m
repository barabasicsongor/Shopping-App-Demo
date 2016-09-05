//
//  ShoppingCartViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ProductDetailViewController.h"
#import "ProductListViewController.h"
#import "ShoppingCartService.h"
#import "Product.h"
#import "PINImageView+PINRemoteImage.h"

static NSString * const kTableViewCellSectionOneIdentifier = @"cell";
static NSString * const kTableViewCellSectionTwoIdentifier = @"cellAdd";

#pragma mark - Class Extension -

@interface ShoppingCartViewController () <UITextFieldDelegate, ProductListViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray<Product *> *shoppingCart;
@property (nonatomic) ShoppingCartService *shoppingCartService;
@property (nonatomic) UITextField *textField;
@property (nonatomic) NSInteger addButtonSectionRowNumber;

@end

#pragma mark - Implementation -

@implementation ShoppingCartViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _shoppingCartService = [ShoppingCartService new];
    _addButtonSectionRowNumber = 1;
    
    [self setupNavigationBarWithType:NavigationBarTypeResetEdit];
    [self tableViewSetup];
    [self loadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:YES];
    [self.tableView setEditing:editing animated:YES];
    if (editing == YES) {
        _addButtonSectionRowNumber = 0;
    } else {
        _addButtonSectionRowNumber = 1;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UI

/**
 *  Set up tableview.
 */
- (void)tableViewSetup {
    [self setupTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSectionHeaderHeight:50.0];
    self.tableView.tableHeaderView = [self createTableHeaderView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 *  Create tableview header, a textfield where the users balance is shown.
 *
 *  @return UIView containing a textfield
 */
- (UIView *)createTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0)];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(50.0, 10.0, self.view.frame.size.width-100, 30.0)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:14.0f];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.text = [_shoppingCartService getFormattedStringWithBalance];
    _textField.delegate = self;
    [headerView addSubview:_textField];
    [self addKeyboardToolbarForTextField:_textField];
    
    return headerView;
}

/**
 *  Add toolbar on top of keyboard to have a Done button after changing the balance.
 *
 *  @param textField UITextField which will have the toolbar on its keyboard.
 */
- (void)addKeyboardToolbarForTextField:(UITextField *)textField {
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(endTextEditing)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    textField.inputAccessoryView = keyboardToolbar;
}

#pragma mark - Callbacks

/**
 *  Method executed when the reset button is pressed. It presents an AlertController, and after if the user wants it resets the shopping cart totally.
 *
 *  @param sender UIButton
 */
- (void)leftBarButtonTouch:(id)sender {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Are you sure you want to reset the shopping cart?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf resetData];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  Method executed when the Done button in the keyboards toolbar is pressed. It saves the new balance and updates the UI accordingly.
 */
- (void)endTextEditing {
    [_textField resignFirstResponder];
    double newBalance = [_textField.text doubleValue];
    
    _textField.text = [NSString stringWithFormat:@"%.1f RON",newBalance];
    [_shoppingCartService saveBalance:[NSNumber numberWithDouble:newBalance]];
    __weak typeof(self) weakSelf = self;
    [_shoppingCartService getRemainingMoneyFromShoppingCart:_shoppingCart withCompletionHandler:^(NSString *title) {
        weakSelf.title = title;
    }];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _shoppingCart.count : _addButtonSectionRowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellSectionOneIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellSectionOneIdentifier];
        }
        Product *product = _shoppingCart[indexPath.row];
        cell.textLabel.text = product.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f RON",product.price];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView pin_setImageFromURL:[NSURL URLWithString:product.imageURL] completion:^(PINRemoteImageManagerResult *result) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellSectionTwoIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellSectionTwoIdentifier];
        }
        cell.textLabel.text = @"Add product";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [_shoppingCartService removeProductAtIndexPath:indexPath fromArray:_shoppingCart withCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.shoppingCart = result;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [strongSelf.shoppingCartService getRemainingMoneyFromShoppingCart:result withCompletionHandler:^(NSString *title) {
            strongSelf.title = title;
        }];
    }];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    __weak typeof(self) weakSelf = self;
    [_shoppingCartService moveProductFromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inArray:_shoppingCart withCompletionHandler:^(NSArray *result) {
        weakSelf.shoppingCart = result;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithProduct:_shoppingCart[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ProductListViewController *vc = [[ProductListViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = [_shoppingCartService getStringWithBalance];
}

#pragma mark - ProductListTableViewControllerDelegate

- (void)didFinishSelectingProducts:(NSArray *)items {
    __weak typeof(self) weakSelf = self;
    
    [_shoppingCartService addItemsToShoppingCart:_shoppingCart fromArray:items withCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.shoppingCart = result;
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [strongSelf.shoppingCartService getRemainingMoneyFromShoppingCart:strongSelf.shoppingCart withCompletionHandler:^(NSString *title) {
            strongSelf.title = title;
        }];
    }];
}

#pragma mark - Helper methods

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [_shoppingCartService loadShoppingCartWithCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.shoppingCart = result;
        [strongSelf.shoppingCartService getRemainingMoneyFromShoppingCart:result withCompletionHandler:^(NSString *title) {
            strongSelf.title = title;
        }];
        [strongSelf.tableView reloadData];
    }];
}

- (void)resetData {
    __weak typeof(self) weakSelf = self;
    [_shoppingCartService resetShoppingCartWithCompletionHandler:^(NSArray *result)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.shoppingCart = result;
        strongSelf.textField.text = [strongSelf.shoppingCartService getFormattedStringWithBalance];
        strongSelf.addButtonSectionRowNumber = 1;
        [strongSelf.tableView reloadData];
        [strongSelf setEditing:NO animated:YES];
        
        [strongSelf.shoppingCartService getRemainingMoneyFromShoppingCart:result withCompletionHandler:^(NSString *title) {
            strongSelf.title = title;
        }];
    }];
}

@end
