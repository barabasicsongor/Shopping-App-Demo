//
//  ProductDetailViewController.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 11/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import UIKit;
#import "BaseViewController.h"

@class Product;

@interface ProductDetailViewController : BaseViewController

- (instancetype)initWithProduct:(Product *)product;

@end
