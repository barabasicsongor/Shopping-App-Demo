//
//  CategoryProductService.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 18/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "CategoryProductService.h"
#import "DatabaseManager.h"
#import "Category.h"
#import "Product.h"
#import "ShopCategories.h"

#pragma mark - Implementation

@implementation CategoryProductService

#pragma mark - Product

/**
 *  Loads all products from database.
 *
 *  @param completionHandler returns NSArray containing all products.
 */
- (void)loadProductsWithCompletionHandler:(void(^)(NSArray *products))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        NSArray *result = [dbManager loadProducts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

/**
 *  The method gets an array with all the records from the shopProducts table from the database as NSDictionaries. Then it extracts just those NSDictionaries containing products, which shopID's are equal to the param's shopID.
 *
 *  @param shop              Shop model, the shop for which the filter is required
 *  @param completionHandler returns an NSArray containing just those dictionaries which represent a product which is available in the param Shop.
 */
- (void)loadProductsForShop:(Shop *)shop withCompletionHandler:(void(^)(NSArray *result))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        
        //Loading arrays
        NSArray *dictionaryArray = [dbManager loadProductsForShop:shop];
        NSArray *categories = [dbManager loadCategories];
        NSArray *products = [dbManager loadProducts];
        NSArray *result = [strongSelf sortProducts:products intoCategories:categories accordingShopList:dictionaryArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

- (void)loadProductsSortedIntoCategoriesWithCompletionHandler:(void(^)(NSArray *products))completionHandler {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        
        //Loading arrays
        NSArray *categories = [dbManager loadCategories];
        NSArray *products = [dbManager loadProducts];
        NSArray *result = [weakSelf sortProducts:products intoCategories:categories];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

#pragma mark - Category

/**
 *  Load all categories from database.
 *
 *  @param completionHandler returns an array containing all categories
 */
- (void)loadCategoriesWithCompletionHandler:(void(^)(NSArray *categories))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        NSArray *result = [dbManager loadCategories];
        
        if (completionHandler) {
            completionHandler(result);
        }
    });
}

- (void)loadCategoryForProduct:(Product *)product withSuccess:(void(^)(Category *result))successHandler andError:(void(^)(void))errorHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        Category *category = [dbManager loadCategoryForProduct:product];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (category == nil) {
                if (errorHandler) {
                    errorHandler();
                }
            } else {
                if (successHandler) {
                    successHandler(category);
                }
            }
        });
    });
}

#pragma mark - Private methods

/**
 *  Sort products into categories according to a shop product list, which is specific to each shop, because it represents the products which each shop contains.
 *
 *  @param products          NSArray containing all products
 *  @param categories        NSArray containing all categories
 *  @param shopList          NSArray containing NSDictionaries which represent a product specific to a shop, because that shop contains that product.
 *  @return returns the resulting array which contains ShopCategories models
 */
- (NSArray *)sortProducts:(NSArray *)products intoCategories:(NSArray *)categories accordingShopList:(NSArray *)shopList {
    NSMutableArray *result = [NSMutableArray new];
    
    //Transform dictionary product id keys to Product models
    NSMutableArray *productObjects = [NSMutableArray new];
    for (NSDictionary *dict in shopList) {
        [productObjects addObject:products[[dict[kProductID] intValue]-1]];
    }
    
    //Create ShopCategories model
    for (Category *category in categories) {
        NSMutableArray *categoryFilter = [NSMutableArray new];
        
        for (Product *product in productObjects) {
            if (product.categoryID == category.categoryID) {
                [categoryFilter addObject:product];
            }
        }
        
        if ([categoryFilter count] > 0) {
            ShopCategories *sc = [[ShopCategories alloc] initWithCategory:category products:[NSArray arrayWithArray:categoryFilter]];
            [result addObject:sc];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

/**
 *  Method sorts products into categories.
 *
 *  @param products          NSArray containig all products.
 *  @param categories        NSArray containing all categories.
 *  @param completionHandler Returns an array containing dictionaries, each dictionary representing a category with its products.
 */
- (NSArray *)sortProducts:(NSArray *)products intoCategories:(NSArray *)categories {
    NSMutableArray *result = [NSMutableArray new];
    
    for (Category *category in categories) {
        NSMutableArray *categoryFilter = [NSMutableArray new];
        
        for (Product *product in products) {
            if (product.categoryID == category.categoryID) {
                [categoryFilter addObject:product];
            }
        }
        
        if ([categoryFilter count] > 0) {
            ShopCategories *sc = [[ShopCategories alloc] initWithCategory:category products:[NSArray arrayWithArray:categoryFilter]];
            [result addObject:sc];
        }
    }
    return [NSArray arrayWithArray:result];
}

@end
