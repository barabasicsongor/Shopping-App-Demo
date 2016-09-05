//
//  ShopDetailViewController.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import UIKit;
#import "BaseViewController.h"

@class Shop;

@interface ShopDetailViewController : BaseViewController

/**
 *  Custom initialization method with a Shop model.
 *
 *  @param shop Shop model
 *
 *  @return instancetype ShopDetailViewController
 */
- (instancetype)initWithShop:(Shop *)shop;

@end
