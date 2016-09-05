//
//  ShopService.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;

@class Shop;

@interface ShopService : NSObject

- (void)loadShopsWithCompletionHandler:(void(^)(NSArray *shops))completionHandler;
- (void)updateFavouriteStateOfShop:(Shop *)shop;
- (void)filterShopsAccordingToString:(NSString *)searchString fromArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *shops))completionHandler;

@end
