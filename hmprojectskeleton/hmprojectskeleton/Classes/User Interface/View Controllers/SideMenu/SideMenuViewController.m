//
//  SideMenuViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "SideMenuViewController.h"
#import "RootViewController.h"
#import "ShoppingCartViewController.h"
#import "ArticlesViewController.h"
#import "RESideMenu.h"

#pragma mark - Class Extension -

@interface SideMenuViewController ()

@end

#pragma mark - Implementation -

@implementation SideMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInterface];
}

#pragma mark - UI

/**
 *  Set up interface.
 */
- (void)setupInterface {
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *shopListButton = [self createButtonWithTitle:@"Shop list"];
    [shopListButton addTarget:self action:@selector(shopListButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopListButton];
    
    UIButton *cartButton = [self createButtonWithTitle:@"Shopping cart"];
    [cartButton addTarget:self action:@selector(cartButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartButton];
    
    UIButton *articlesButton = [self createButtonWithTitle:@"Articles"];
    [articlesButton addTarget:self action:@selector(articlesButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:articlesButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(shopListButton, cartButton, articlesButton);
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *metrics = @{@"buttonHeight":@35,
                              @"buttonWidth":@120};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[shopListButton(buttonHeight)]-5-[cartButton(buttonHeight)]-5-[articlesButton(buttonHeight)]" options:(NSLayoutFormatOptions)(NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing) metrics:metrics views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:cartButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[shopListButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[articlesButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[cartButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

/**
 *  Gets called when the ShopList button is tapped and it shows the RootTableViewController, which contains the list of all shops.
 *
 *  @param sender UIButton
 */
- (void)shopListButtonTouch:(UIButton *)sender {
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self.sideMenuViewController setContentViewController:navController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

/**
 *  Gets called when the ShoppingCart button is tapped and it shows the ShoppingCartTableViewController, which contains the users shopping cart.
 *
 *  @param sender UIButton
 */
- (void)cartButtonTouch:(UIButton *)sender {
    ShoppingCartViewController *scViewController = [ShoppingCartViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scViewController];
    
    [self.sideMenuViewController setContentViewController:navController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)articlesButtonTouch:(UIButton *)sender {
    ArticlesViewController *articlesViewController = [ArticlesViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:articlesViewController];
    
    [self.sideMenuViewController setContentViewController:navController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - Helper methods

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor blackColor];
    
    return button;
}

@end
