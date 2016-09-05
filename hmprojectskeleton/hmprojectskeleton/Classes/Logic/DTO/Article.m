//
//  Article.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "Article.h"

@implementation Article

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _title = data[@"headline"];
        _imageURL = data[@"cover_image"][@"file"][@"thumb_large"][@"src"];
        _descriptionText = data[@"short_description"];
    }
    return self;
}

@end
