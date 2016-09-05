//
//  ShoppingCartService.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 14/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;

@interface ShoppingCartService : NSObject

//Shopping cart
- (void)loadShoppingCartWithCompletionHandler:(void(^)(NSArray *result))completionHandler;
- (void)addItemsToShoppingCart:(NSArray *)shoppingCart fromArray:(NSArray *)items withCompletionHandler:(void(^)(NSArray *result))completionHandler;
- (void)moveProductFromIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)destionation inArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *result))completionHandler;
- (void)removeProductAtIndexPath:(NSIndexPath *)source fromArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *result))completionHandler;
- (void)getRemainingMoneyFromShoppingCart:(NSArray *)shoppingCart withCompletionHandler:(void(^)(NSString *result))completionHandler;
- (void)resetShoppingCartWithCompletionHandler:(void(^)(NSArray *result))completionHandler;

//UserDefaultsManager
- (NSString *)getStringWithBalance;
- (NSString *)getFormattedStringWithBalance;
- (void)saveBalance:(NSNumber *)balance;
- (NSArray *)getShoppingCart;
- (void)setShoppingCart:(NSArray *)shoppingCart;

@end
