//
//  UserDefaultsManager.m
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

#import "UserDefaultsManager.h"

static NSString * const kUserDefaultsKeyShouldClearKeychain                     = @"shouldClearKeychain";

#pragma mark - Implementation -

@implementation UserDefaultsManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
	SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerDefaults];
        [self loadDefaults];
    }
    
    return self;
}

#pragma mark - Default values

- (void)registerDefaults {
    NSDictionary *userDefaultsDefaults = @{kNSUserDefaultsBalance:[NSNumber numberWithDouble:100.0],
                                           kNSUserDefaultsShoppingCart:[NSArray array]};
    [UserDefaults registerDefaults:userDefaultsDefaults];
}

- (void)loadDefaults {
    _shoppingCart = [UserDefaults objectForKey:kNSUserDefaultsShoppingCart];
    _balance = [UserDefaults objectForKey:kNSUserDefaultsBalance];
}

#pragma mark - Setter / Getter methods

- (void)setBalance:(NSNumber *)balance {
    _balance = balance;
    [UserDefaults setObject:balance forKey:kNSUserDefaultsBalance];
}

- (void)setShoppingCart:(NSArray *)shoppingCart {
    _shoppingCart = shoppingCart;
    [UserDefaults setObject:shoppingCart forKey:kNSUserDefaultsShoppingCart];
}

@end
