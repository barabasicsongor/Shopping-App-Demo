//
//  ShoppingCartService.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 14/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ShoppingCartService.h"
#import "DatabaseManager.h"
#import "Product.h"
#import "UserDefaultsManager.h"

#pragma mark - Implementation -

@implementation ShoppingCartService

#pragma mark - Public methods

- (void)loadShoppingCartWithCompletionHandler:(void(^)(NSArray *result))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        NSArray *products = [dbManager loadProducts];
        
        NSMutableArray *shoppingCart = [NSMutableArray arrayWithCapacity:0];
        for (NSNumber *productID in defaultsManager.shoppingCart) {
            
            for (Product *product in products) {
                if (product.productID == [productID integerValue]) {
                    [shoppingCart addObject:product];
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([NSArray arrayWithArray:shoppingCart]);
            }
        });
    });
}

- (void)addItemsToShoppingCart:(NSArray *)shoppingCart fromArray:(NSArray *)items withCompletionHandler:(void(^)(NSArray *result))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
        NSMutableArray *defaultsArray = [NSMutableArray arrayWithArray:defaultsManager.shoppingCart];
        NSMutableArray *shoppingCartHelper = [NSMutableArray arrayWithArray:shoppingCart];
        
        for (Product *product in items) {
            [shoppingCartHelper addObject:product];
            [defaultsArray addObject:[NSNumber numberWithInteger:product.productID]];
        }
        [defaultsManager setShoppingCart:[NSArray arrayWithArray:defaultsArray]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([NSArray arrayWithArray:shoppingCartHelper]);
            }
        });
    });
}

/**
 *  Move a Product model in an array from one index to another. Then saves that array to the NSUserDefaults because it represents the current shopping cart.
 *
 *  @param source            Source NSIndexPath of product.
 *  @param destionation      Destination NSIndexPath of product.
 *  @param array             Array in which the movement should be made.
 *  @param completionHandler The param array is returned with the movements made.
 */
- (void)moveProductFromIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)destionation inArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *result))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *workingArray = [NSMutableArray arrayWithArray:array];
        Product *product = [workingArray objectAtIndex:source.row];
        [workingArray removeObjectAtIndex:source.row];
        [workingArray insertObject:product atIndex:destionation.row];
        NSArray *result = [NSArray arrayWithArray:workingArray];
        [weakSelf updateUserDefaultsWithShoppingCartArray:result];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

/**
 *  Remove a Product model in an array from an index. Then save that array to the NSUserDefaults because it represents the users current shopping cart.
 *
 *  @param source            NSIndexPath of the product.
 *  @param array             Array from where the object has to be removed.
 *  @param completionHandler Returns the param array with the removing made.
 */
- (void)removeProductAtIndexPath:(NSIndexPath *)source fromArray:(NSArray *)array withCompletionHandler:(void(^)(NSArray *result))completionHandler {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *workingArray = [NSMutableArray arrayWithArray:array];
        [workingArray removeObjectAtIndex:source.row];
        NSArray *result = [NSArray arrayWithArray:workingArray];
        [weakSelf updateUserDefaultsWithShoppingCartArray:result];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(result);
            }
        });
    });
}

/**
 *  Calculate the remaining money of the user by extracting each products price from the users main balance.
 *
 *  @param shoppingCart Array containing all products that are in the shopping cart.
 *
 *  @return NSString formated that it can be displayed directly, showing the users remaining money.
 */
- (void)getRemainingMoneyFromShoppingCart:(NSArray *)shoppingCart withCompletionHandler:(void(^)(NSString *result))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
        double balance = [defaultsManager.balance doubleValue];
        double shoppingCartValue = 0.0;
        
        for (Product *product in shoppingCart) {
            shoppingCartValue += product.price;
        }
        balance = balance - shoppingCartValue;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([NSString stringWithFormat:@"Money : %.1f RON",balance]);
            }
        });
    });
}

/**
 *  Reset the shopping cart in the NSUserDefaults by setting an empty array and the balance to 100.0 RON.
 *
 *  @param completionHandler Return an empty array, representing the current shopping cart.
 */
- (void)resetShoppingCartWithCompletionHandler:(void(^)(NSArray *result))completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
        [defaultsManager setShoppingCart:[NSArray array]];
        [defaultsManager setBalance:[NSNumber numberWithDouble:100.0]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([NSArray array]);
            }
        });
    });
}

#pragma mark - UserDefaultsManager

- (NSString *)getFormattedStringWithBalance {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    return [NSString stringWithFormat:@"%.1f RON",[defaultsManager.balance doubleValue]];
}

- (NSString *)getStringWithBalance {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    return [NSString stringWithFormat:@"%.1f",[defaultsManager.balance doubleValue]];
}

- (void)saveBalance:(NSNumber *)balance {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    [defaultsManager setBalance:balance];
}

- (NSArray *)getShoppingCart {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    return defaultsManager.shoppingCart;
}

- (void)setShoppingCart:(NSArray *)shoppingCart {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    [defaultsManager setShoppingCart:shoppingCart];
}

#pragma mark - Private methods

/**
 *  Update the NSUserDefaults by saving an array with each products ID.
 *
 *  @param array Array representing the shopping cart with Product models.
 */
- (void)updateUserDefaultsWithShoppingCartArray:(NSArray *)array {
    UserDefaultsManager *defaultsManager = [UserDefaultsManager sharedInstance];
    NSMutableArray *result = [NSMutableArray new];
    for (Product *product in array) {
        [result addObject:[NSNumber numberWithInteger:product.productID]];
    }
    [defaultsManager setShoppingCart:[NSArray arrayWithArray:result]];
}

@end
