//
//  ArticlesViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ArticlesViewController.h"
#import "ArticleDetailViewController.h"
#import "ArticleCollectionViewCell.h"
#import "ArticleService.h"
#import "Article.h"
#import "RESideMenu.h"

#define kCollectionViewCellHeight (self.view.frame.size.width + 70.0)
#define kCollectionViewCellWidth self.view.frame.size.width

static NSString * const kCollectionViewCellIdentifier = @"cell";

#pragma mark - Class Extension -

@interface ArticlesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) ArticleService *articleService;
@property (nonatomic) NSArray<Article *> *articles;
@property (nonatomic) UICollectionView *collectionView;

@end

#pragma mark - Implementation

@implementation ArticlesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setupNavigationBar];
    [self setupCollectionView];
}

#pragma mark - UI

- (void)setupNavigationBar {
    self.title = @"Articles";
    [self setupNavigationBarWithType:NavigationBarTypeSideMenu];
}

- (void)setupCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(kCollectionViewCellWidth,kCollectionViewCellHeight)];
    flowLayout.minimumLineSpacing = 10.0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ArticleCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [self.view addSubview:_collectionView];
    
    id topLayoutGuide = (UIView *)self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(topLayoutGuide,_collectionView);
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_collectionView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

- (void)leftBarButtonTouch:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - UICollectionViewDelegate & Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _articles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    [cell setArticle:_articles[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] initWithArticle:_articles[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper methods

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    _articleService = [ArticleService new];
    [_articleService loadArticlesWithCompletionHandler:^(NSArray *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.articles = result;
        [strongSelf.collectionView reloadData];
        strongSelf.collectionView.backgroundColor = [UIColor lightGrayColor];
    }];
}

@end
