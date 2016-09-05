//
//  ShopTableViewCell.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "Shop.h"

#pragma mark - Class Extension -

@interface ShopTableViewCell()

@property (nonatomic) UIButton *favouriteButton;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *distanceLabel;

@end

#pragma mark - Implementation

@implementation ShopTableViewCell

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
 *  Set up interface of the table view cell.
 */
- (void)setupInterface {
    _favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _favouriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_favouriteButton addTarget:self action:@selector(favouriteButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_favouriteButton];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:_titleLabel.font.fontName size:20.0];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    _distanceLabel = [UILabel new];
    _distanceLabel.font = [UIFont fontWithName:_distanceLabel.font.fontName size:11.0];
    _distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_distanceLabel];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(_favouriteButton, _titleLabel, _distanceLabel);
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_favouriteButton]-5-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_favouriteButton]" options:0 metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_favouriteButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_favouriteButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_titleLabel]" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_favouriteButton]-5-[_titleLabel]" options:0 metrics:nil views:views]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_distanceLabel]-5-|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_favouriteButton]-5-[_distanceLabel]" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

/**
 *  Callback method for the favourite button on the table view cell, which calls the delegate method.
 */
- (void)favouriteButtonTouch {
    [self.delegate didPressFavouriteButtonForShop:_shop];
}

#pragma mark - Getter/Setter

/**
 *  Overridden method of Shop setter.Load data from Shop model into tableview cell.
 *
 *  @param shop - Shop model
 */
- (void)setShop:(Shop *)shop {
    if (shop.favouriteState == YES) {
        [_favouriteButton setImage:[UIImage imageNamed:@"starTrue"] forState:UIControlStateNormal];
    } else {
        [_favouriteButton setImage:[UIImage imageNamed:@"starFalse"] forState:UIControlStateNormal];
    }
    _titleLabel.text = shop.name;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (shop.distanceFromUser >= 0) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f m",shop.distanceFromUser];
    } else {
        _distanceLabel.text = @"--";
    }
    _shop = shop;
}

@end
