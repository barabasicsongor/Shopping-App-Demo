//
//  ProductListTableViewController.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

@import UIKit;
#import "BaseViewController.h"

@protocol ProductListViewControllerDelegate <NSObject>

@required
/**
 *  Delegate method, which returns an array with the selected products from the Product List.
 *
 *  @param items Array containing the selected Product models.
 */
- (void)didFinishSelectingProducts:(NSArray *)items;

@end

@interface ProductListViewController : BaseViewController

@property (nonatomic, weak) id<ProductListViewControllerDelegate> delegate;

@end
