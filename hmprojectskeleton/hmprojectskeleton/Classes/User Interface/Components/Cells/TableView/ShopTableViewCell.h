//
//  ShopTableViewCell.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 10/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shop;

@protocol ShopTableViewCellDelegate <NSObject>

@required
/**
 *  Delegate method for the favourite button on the table view cells.
 *
 *  @param shop - Shop type, representing the shop of that cell.
 */
- (void)didPressFavouriteButtonForShop:(Shop *)shop;

@end

@interface ShopTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShopTableViewCellDelegate> delegate;
@property (nonatomic) Shop *shop;

@end
