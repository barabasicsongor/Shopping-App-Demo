//
//  HMPFont.m
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

#import "HMPFont.h"

// TODO: Set font names!
static NSString * const kFontNameLight                      = @"";
static NSString * const kFontNameRegular                    = @"";
static NSString * const kFontNameBold                       = @"";

@implementation HMPFont

+ (UIFont *)lightFontWithSize:(FontSize)size {
    CGFloat fontSize =[self.class floatFromFontSize:size];
    return [UIFont fontWithName:kFontNameLight size:fontSize];
}

+ (UIFont *)regularFontWithSize:(FontSize)size {
    CGFloat fontSize =[self.class floatFromFontSize:size];
    return [UIFont fontWithName:kFontNameRegular size:fontSize];
}

+ (UIFont *)boldFontWithSize:(FontSize)size {
    CGFloat fontSize =[self.class floatFromFontSize:size];
    return [UIFont fontWithName:kFontNameBold size:fontSize];
}

#pragma mark - Private

+ (CGFloat)floatFromFontSize:(FontSize)size {
    CGFloat fontSize = (CGFloat)size;
    return fontSize;
}

@end
