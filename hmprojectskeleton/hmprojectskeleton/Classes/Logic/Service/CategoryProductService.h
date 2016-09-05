//
//  CategoryProductService.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 18/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;

@class Shop;
@class Category;
@class Product;

@interface CategoryProductService : NSObject

//Product
- (void)loadProductsWithCompletionHandler:(void(^)(NSArray *products))completionHandler;
- (void)loadProductsForShop:(Shop *)shop withCompletionHandler:(void(^)(NSArray *result))completionHandler;
- (void)loadProductsSortedIntoCategoriesWithCompletionHandler:(void(^)(NSArray *products))completionHandler;

//Category
- (void)loadCategoriesWithCompletionHandler:(void(^)(NSArray *categories))completionHandler;
- (void)loadCategoryForProduct:(Product *)product withSuccess:(void(^)(Category *result))successHandler andError:(void(^)(void))errorHandler;

@end
