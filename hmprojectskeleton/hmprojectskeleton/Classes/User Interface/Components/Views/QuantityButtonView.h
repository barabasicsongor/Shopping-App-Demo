//
//  QuantityButtonView.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 12/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuantityButtonViewDelegate <NSObject>

@required
/**
 *  Delegate method for callback of quantity button. Action gets executed once the button on the view is pressed.
 */
- (void)didPressQuantityButton;

@end

@interface QuantityButtonView : UIView

@property (nonatomic, weak) id<QuantityButtonViewDelegate> delegate;
- (void)updateQuantityWithValue:(int)value;

@end
