//
//  Article.h
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)data;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *descriptionText;
@property (nonatomic) NSString *imageURL;

@end
