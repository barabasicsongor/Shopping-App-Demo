//
//  DatabaseManager.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import "FMDatabaseQueue.h"
#import "Shop.h"
#import "Product.h"
#import "Category.h"

#pragma mark - Class Extension -

@interface DatabaseManager()

@property (nonatomic) FMDatabaseQueue *databaseQueue;

@end

#pragma mark - Implementation -

@implementation DatabaseManager

#pragma mark - Shared Instance

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance initDatabase];
    });
    
    return sharedInstance;
}

#pragma mark - Lifecycle

/**
 *  Custom initialization method.
 *  If database is not saved to disk, method saves database to disk.
 *  Method loads database from disk.
 */
- (void)initDatabase {
    NSString *databaseName = @"FirstAppDatabase.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if (!success) {
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
}

#pragma mark - Load functions

/**
 *  Load all shops from database and parse them in Shop model.
 *
 *  @return NSArray containing all shops like Shop models.
 */
- (NSArray *)loadShops {
    NSMutableArray *shops = [NSMutableArray new];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT *,rowid FROM shops"];
        while ([set next]) {
            [shops addObject:[[Shop alloc] initWithSet:set]];
        }
    }];
    
    return [NSArray arrayWithArray:shops];
}

/**
 *  Load all categories from database and parse them in Category model.
 *
 *  @return NSArray containing all categories like Category models.
 */
- (NSArray *)loadCategories {
    NSMutableArray *categories = [NSMutableArray new];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM categories"];
        while ([set next]) {
            [categories addObject:[[Category alloc] initWithSet:set]];
        }
    }];
    return [NSArray arrayWithArray:categories];
}

/**
 *  Load all products from database and parse them in Product model.
 *
 *  @return NSArray containing all products like Product models.
 */
- (NSArray *)loadProducts {
    NSMutableArray *products = [NSMutableArray new];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT *,rowid FROM products"];
        while ([set next]) {
            [products addObject:[[Product alloc] initWithSet:set]];
        }
    }];
    return [NSArray arrayWithArray:products];
}

/**
 *  Load all records from shopProducts table from database. Then parse record into dictionary, each dictionary representing a product in a specific shop.
 *  NOTE:Products can repeat themselves, but shopID makes them distinct.
 *
 *  @return NSArray containing NSDictionaries with products specific for each shop.
 */
- (NSArray *)loadProductsForShop:(Shop *)shop {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM shopProducts WHERE shopRowID='%ld'",(long)shop.shopID];
    
    NSMutableArray *shopProducts = [NSMutableArray new];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:query];
        while([set next]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary new];
            [dictionary setObject:[NSNumber numberWithInt:[set intForColumn:@"shopRowID"]] forKey:kShopID];
            [dictionary setObject:[NSNumber numberWithInt:[set intForColumn:@"productRowID"]] forKey:kProductID];
            [shopProducts addObject:[NSDictionary dictionaryWithDictionary:dictionary]];
        }
    }];
    return [NSArray arrayWithArray:shopProducts];
}

- (Category *)loadCategoryForProduct:(Product *)product {
    __block Category *category;
    
    NSString *query = [NSString stringWithFormat:@"SELECT *,rowid FROM categories WHERE categoryID='%ld'",(long)product.categoryID];
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:query];
        while ([set next]) {
            category = [[Category alloc] initWithSet:set];
        }
    }];
    
    return category;
}

#pragma mark - Update queries

/**
 *  Creates a query string and with it invokes a update method which updates the database.
 *
 *  @param name  name of Shop to update
 *  @param state favouriteState that will be sent into the database
 */
- (void)updateFavouriteStateOfShopWithName:(NSString *)name state:(BOOL)state {
    [self makeUpdateWithQuery:[NSString stringWithFormat:@"UPDATE shops SET favouriteState='%d' WHERE name='%@'",state,name]];
}

#pragma mark - Private methods

/**
 *  Method executes an update query in the database.
 *
 *  @param query NSString containing a SQL query.
 */
- (void)makeUpdateWithQuery:(NSString *)query {
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query];
    }];
}

@end
