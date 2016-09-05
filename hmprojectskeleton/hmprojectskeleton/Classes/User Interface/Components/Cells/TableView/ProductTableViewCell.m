//
//  ProductTableViewCell.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 11/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "Product.h"
#import "PINImageView+PINRemoteImage.h"

#pragma mark - Class Extension -

@interface ProductTableViewCell()

@property (nonatomic) UIImageView *productImageView;
@property (nonatomic) UILabel *titleLabel;

@end

#pragma mark - Implementation

@implementation ProductTableViewCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInterface];
    }
    return self;
}

#pragma mark - UI

/**
 *  Set up interface of table view cell
 */
- (void)setupInterface {
    _productImageView = [UIImageView new];
    _productImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_productImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:_titleLabel.font.fontName size:16.0];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(_productImageView, _titleLabel);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_productImageView]-5-[_titleLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_productImageView]-5-|" options:0 metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_productImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_productImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Setter/Getter

/**
 *  Overridden method.Load data in table view cell from Product model.
 *
 *  @param product Product model representing a product
 */
- (void)setProduct:(Product *)product {
    _titleLabel.text = product.name;
    
    [_productImageView setPin_updateWithProgress:YES];
    [_productImageView pin_setImageFromURL:[NSURL URLWithString:product.imageURL]];
}

@end
