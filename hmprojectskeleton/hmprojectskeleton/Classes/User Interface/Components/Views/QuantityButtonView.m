//
//  QuantityButtonView.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "QuantityButtonView.h"

#pragma mark - Class Extension -

@interface QuantityButtonView()

@property (nonatomic) UILabel *quantityLabel;

@end

#pragma mark - Implementation -

@implementation QuantityButtonView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInterface];
    }
    return self;
}

#pragma mark - UI

/**
 *  Set up interface of the view.
 */
- (void)setupInterface {
    _quantityLabel = [UILabel new];
    _quantityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _quantityLabel.font = [UIFont fontWithName:_quantityLabel.font.fontName size:14.0];
    _quantityLabel.text = @"1";
    [self addSubview:_quantityLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor redColor];
    [button setImage:[UIImage imageNamed:@"icKeyboardArrowDown"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10.0;
    [button addTarget:self action:@selector(quantityButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(_quantityLabel, button);
    NSDictionary *metrics = @{@"buttonWidth":@30};
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_quantityLabel]" options:0 metrics:nil views:views]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_quantityLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(buttonWidth)]|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Callbacks

/**
 *  Method executed once the button on the view is tapped. It calls the delegate method.
 *
 *  @param sender Button
 */
- (void)quantityButtonTouch:(UIButton *)sender {
    [self.delegate didPressQuantityButton];
}

#pragma mark - Public methods

/**
 *  Update the label on the button with the current value selected from the picker view.
 *
 *  @param value Int - value selected
 */
- (void)updateQuantityWithValue:(int)value {
    _quantityLabel.text = [NSString stringWithFormat:@"%d",value];
}

@end
