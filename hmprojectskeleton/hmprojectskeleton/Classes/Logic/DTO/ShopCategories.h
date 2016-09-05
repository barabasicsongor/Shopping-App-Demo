//
//  ShopProducts.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 17/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "Category.h"

@interface ShopCategories : Category

- (instancetype)initWithCategory:(Category *)category products:(NSArray *)products;
@property (nonatomic) NSArray *products;

@end
