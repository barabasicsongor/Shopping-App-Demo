//
//  ArticleCollectionViewCell.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 23/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ArticleCollectionViewCell.h"
#import "Article.h"
#import "PINImageView+PINRemoteImage.h"

#pragma mark - Class Extension -

@interface ArticleCollectionViewCell()

@property (nonatomic) UIImageView *image;
@property (nonatomic) UILabel *titleLabel;

@end

#pragma mark - Implementation -

@implementation ArticleCollectionViewCell

#pragma mark - Init methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    _image = [UIImageView new];
    _image.translatesAutoresizingMaskIntoConstraints = NO;
    _image.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_image];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:_titleLabel.font.fontName size:25.0];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_image, _titleLabel);
    NSDictionary *metrics = @{@"labelMargin":@15};
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_image]|" options:0 metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_image attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_image attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(labelMargin)-[_titleLabel]-(labelMargin)-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_image]-(labelMargin)-[_titleLabel]" options:0 metrics:metrics views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Setter/Getter

- (void)setArticle:(Article *)article {
    _article = article;
    _titleLabel.text = article.title;
    [_image pin_setImageFromURL:[NSURL URLWithString:article.imageURL]];
}

@end
