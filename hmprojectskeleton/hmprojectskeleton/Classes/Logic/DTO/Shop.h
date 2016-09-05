//
//  Shop.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;
#import "FMDB.h"

@interface Shop : NSObject

/**
 *  Custom initialization method.
 *
 *  @param set FMResultSet, a record from the database.
 *
 *  @return instancetype Shop
 */
- (instancetype)initWithSet:(FMResultSet *)set;

@property (nonatomic) NSString *name;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSInteger shopID;
@property (nonatomic) double distanceFromUser;
@property (nonatomic) BOOL favouriteState;

@end
