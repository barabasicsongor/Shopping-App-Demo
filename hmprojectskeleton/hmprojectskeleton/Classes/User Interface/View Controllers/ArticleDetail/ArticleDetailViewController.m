//
//  ArticleDetailViewController.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 23/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "Article.h"
#import "PINImageView+PINRemoteImage.h"

#pragma mark - Class Extension -

@interface ArticleDetailViewController ()

@property (nonatomic) Article *article;
@property (nonatomic) UIImageView *image;
@property (nonatomic) UILabel *descriptionLabel;

@end

#pragma mark - Implementation -

@implementation ArticleDetailViewController

#pragma mark - Lifecycle

- (instancetype)initWithArticle:(Article *)article {
    self = [super init];
    if (self) {
        _article = article;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupUI];
}

#pragma mark - UI

- (void)setupNavigationBar {
    self.title = _article.title;
    [self setupNavigationBarWithType:NavigationBarTypeBack];
}

- (void)setupUI {
    [self setupScrollView];
    
    _image = [UIImageView new];
    _image.translatesAutoresizingMaskIntoConstraints = NO;
    _image.contentMode = UIViewContentModeScaleToFill;
    [_image pin_setImageFromURL:[NSURL URLWithString:_article.imageURL]];
    [self.contentView addSubview:_image];
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_descriptionLabel];
    
    //Show HTML text in label
    if (_article.descriptionText != (id)[NSNull null]) {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[_article.descriptionText dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        _descriptionLabel.attributedText = attrStr;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_image, _descriptionLabel);
    NSDictionary *metrics = @{@"margin":@15};
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_image]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[_descriptionLabel]-(margin)-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_image]-(margin)-[_descriptionLabel]|" options:0 metrics:metrics views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_image attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

- (void)leftBarButtonTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
