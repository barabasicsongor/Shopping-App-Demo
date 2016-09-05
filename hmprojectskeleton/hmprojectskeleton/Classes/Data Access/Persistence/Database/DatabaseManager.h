//
//  DatabaseManager.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;

@class Shop;
@class Category;
@class Product;

@interface DatabaseManager : NSObject

//Shared instance
+ (instancetype)sharedInstance;

//Load methods
- (NSArray *)loadShops;
- (NSArray *)loadCategories;
- (NSArray *)loadProducts;
- (NSArray *)loadProductsForShop:(Shop *)shop;
- (Category *)loadCategoryForProduct:(Product *)product;

//Update methods
- (void)updateFavouriteStateOfShopWithName:(NSString *)name state:(BOOL)state;

@end
