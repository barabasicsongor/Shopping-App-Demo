//
//  PriceView.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "PriceView.h"

#pragma mark - Implementation

@implementation PriceView

#pragma mark - Lifecycle

/**
 *  Custom initialization method.
 *
 *  @param price Price of the product.
 *
 *  @return instancetype - PriceView
 */
- (instancetype)initWithPrice:(NSString *)price {
    self = [super init];
    if (self) {
        [self setupInterfaceWithPrice:price];
    }
    return self;
}

#pragma mark - UI

/**
 *  Set up interface of the view.
 *
 *  @param price The price of the product.
 */
- (void)setupInterfaceWithPrice:(NSString *)price {
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.text = @"Price";
    [self addSubview:titleLabel];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    priceLabel.font = [UIFont fontWithName:priceLabel.font.fontName size:30.0];
    priceLabel.text = price;
    [self addSubview:priceLabel];
    
    UILabel *commentLabel = [UILabel new];
    commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    commentLabel.font = [UIFont fontWithName:commentLabel.font.fontName size:10.0];
    commentLabel.textColor = [UIColor redColor];
    commentLabel.text = @"plus shipping";
    [self addSubview:commentLabel];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, priceLabel, commentLabel);
    NSDictionary *metrics = @{@"margin":@15};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[titleLabel]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[priceLabel]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[commentLabel]" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel][priceLabel][commentLabel]" options:0 metrics:metrics views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

@end
