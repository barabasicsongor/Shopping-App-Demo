//
//  Shop.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "Shop.h"

static double const kUnknownDistance = -1.0;

#pragma mark - Implementation -

@implementation Shop

#pragma mark - Lifecycle

- (instancetype)initWithSet:(FMResultSet *)set {
    self = [super init];
    if (self) {
        _name = [set stringForColumn:kShopName];
        _latitude = [set doubleForColumn:kShopLatitude];
        _longitude = [set doubleForColumn:kShopLongitude];
        _favouriteState = [set boolForColumn:kShopFavouriteState];
        _shopID = [set intForColumn:kShopRowID];
        _distanceFromUser = kUnknownDistance;
    }
    return self;
}

@end
