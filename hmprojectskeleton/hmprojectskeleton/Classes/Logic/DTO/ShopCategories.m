//
//  ShopProducts.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 17/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ShopCategories.h"

#pragma mark - Implementation

@implementation ShopCategories

#pragma mark - Lifecycle

- (instancetype)initWithCategory:(Category *)category products:(NSArray *)products {
    self = [super init];
    if (self) {
        self.name = category.name;
        self.categoryID = category.categoryID;
        self.products = products;
    }
    return self;
}

@end
