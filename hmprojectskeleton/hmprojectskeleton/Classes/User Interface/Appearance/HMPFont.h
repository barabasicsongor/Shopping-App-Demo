//
//  HMPFont.h
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

typedef NS_ENUM(NSInteger, FontSize) {
    FontSizeSmall       = 11,
    FontSizeMediumSmall = 13,
    FontSizeMedium      = 15,
    FontSizeMediumLarge = 17,
    FontSizeLarge       = 21,
    FontSizeLargeExtra  = 28
};

@interface HMPFont : NSObject

+ (UIFont *)lightFontWithSize:(FontSize)size;
+ (UIFont *)regularFontWithSize:(FontSize)size;
+ (UIFont *)boldFontWithSize:(FontSize)size;

@end
