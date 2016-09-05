//
//  Category.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import Foundation;
#import "FMDB.h"

@interface Category : NSObject

/**
 *  Custom initialization method.
 *
 *  @param set FMResultSet, a record from database.
 *
 *  @return instancetype Category
 */
- (instancetype)initWithSet:(FMResultSet *)set;

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger categoryID;

@end
