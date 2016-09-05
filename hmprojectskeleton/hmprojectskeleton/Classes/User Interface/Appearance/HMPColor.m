//
//  HMPColor.m
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

#import "HMPColor.h"
#import "UIColor+HEX.h"

static UIColor *_blackColor;

UIColor* InitColorVariable(UIColor *color, NSInteger value);

#pragma mark - Implementation -

@implementation HMPColor

+ (UIColor *)blackColor {
    // TODO: Set black color hexa code from the design or remove/refactor black color method if custom black color is not needed
    _blackColor = InitColorVariable(_blackColor, 0x2a2a33);
    return _blackColor;
}

+ (UIColor *)clearColor {
    return [UIColor clearColor];
}

#pragma mark :: white

+ (UIColor *)whiteColor {
    return [UIColor whiteColor];
}

#pragma mark - Convenience

UIColor* InitColorVariable(UIColor *color, NSInteger value) {
    if (!color) {
        color = [UIColor colorWithHexInteger:value];
    }
    return color;
}

@end
