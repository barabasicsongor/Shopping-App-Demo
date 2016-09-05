//
//  Category.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "Category.h"

#pragma mark - Implementation -

@implementation Category

#pragma mark - Lifecycle

- (instancetype)initWithSet:(FMResultSet *)set {
    self = [super init];
    if (self) {
        _name = [set stringForColumn:kCategoryName];
        _categoryID = [set intForColumn:kCategoryID];
    }
    return self;
}

@end
