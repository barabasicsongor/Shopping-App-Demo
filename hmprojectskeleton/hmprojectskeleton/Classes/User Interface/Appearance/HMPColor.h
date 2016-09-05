//
//  HMPColor.h
//  hmprojectskeleton
//
//  Created by Tamas Levente on 5/29/15.
//  Copyright (c) 2015 halcyonmobile. All rights reserved.
//

#define kColorClear                     [HMPColor clearColor]
#define kColorBlack                     [HMPColor blackColor]
#define kColorWhite                     [HMPColor whiteColor]

@interface HMPColor : NSObject

+ (UIColor *)clearColor;
+ (UIColor *)blackColor;
+ (UIColor *)whiteColor;

@end
