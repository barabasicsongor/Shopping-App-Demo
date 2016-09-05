//
//  Product.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "Product.h"

#pragma mark - Implementation -

@implementation Product

#pragma mark - Lifecycle

- (instancetype)initWithSet:(FMResultSet *)set {
    self = [super init];
    if (self) {
        _name = [set stringForColumn:kProductName];
        _price = [set doubleForColumn:kProductPrice];
        _imageURL = [set stringForColumn:kProductImageURL];
        _categoryID = [set intForColumn:kProductCategoryID];
        _productID = [set intForColumn:kProductRowID];
    }
    return self;
}

@end
