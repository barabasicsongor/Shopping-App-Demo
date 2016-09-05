//
//  Product.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;
#import "FMDB.h"

@interface Product : NSObject

/**
 *  Custom initialization method.
 *
 *  @param set FMResultSet, a record from the database.
 *
 *  @return instancetype Product
 */
- (instancetype)initWithSet:(FMResultSet *)set;

@property (nonatomic) NSString *name;
@property (nonatomic) double price;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSInteger categoryID;
@property (nonatomic) NSInteger productID;

@end
