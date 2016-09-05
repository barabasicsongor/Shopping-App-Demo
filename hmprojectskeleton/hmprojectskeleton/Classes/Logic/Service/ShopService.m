//
//  ShopService.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ShopService.h"
#import "DatabaseManager.h"
#import "Shop.h"

#pragma mark - Implementation -

@implementation ShopService

#pragma mark - Public methods

/**
 *  Load all shops from database.
 *
 *  @param completionHandler - returns an array with all shops.
 */
- (void)loadShopsWithCompletionHandler:(void(^)(NSArray *shops))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        NSArray *result = [dbManager loadShops];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

/**
 *  Update the favourite state of the shop in the database.
 *
 *  @param shop Shop model, representing the shop which favourite state has to be updated.
 */
- (void)updateFavouriteStateOfShop:(Shop *)shop {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        [dbManager updateFavouriteStateOfShopWithName:shop.name state:shop.favouriteState];
    });
}

/**
 *  Search method helper, filters shops which name contains a specific string.
 *
 *  @param searchString The specific string which has to be in the shop name.
 *  @param array        Array in which the method should search and find Shops.
 *
 *  @return array of Shop models, it contains those shops which name contain the searchString param.
 */
- (void)filterShopsAccordingToString:(NSString *)searchString fromArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *shops))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *searchResult = [NSMutableArray new];
        NSString *str = [searchString uppercaseString];
        
        for (Shop *shop in array) {
            if ([[shop.name uppercaseString] containsString:str]) {
                [searchResult addObject:shop];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([NSArray arrayWithArray:searchResult]);
            }
        });
    });
}

@end
