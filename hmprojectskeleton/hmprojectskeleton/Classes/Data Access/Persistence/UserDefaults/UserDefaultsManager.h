//
//  UserDefaultsManager.h
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

@interface UserDefaultsManager : NSObject

@property (nonatomic) NSArray *shoppingCart;
@property (nonatomic) NSNumber *balance;

+ (instancetype)sharedInstance;

@end
