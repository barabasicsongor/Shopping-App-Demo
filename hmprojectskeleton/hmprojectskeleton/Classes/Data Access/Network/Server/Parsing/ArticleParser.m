//
//  ArticleParser.m
//  hmprojectskeleton
//
//  Created by Csongor Barabasi on 22/08/16.
//  Copyright © 2016 halcyonmobile. All rights reserved.
//

#import "ArticleParser.h"
#import "Article.h"

@implementation ArticleParser

- (void)parseDictionaryIntoArticlesArray:(NSDictionary *)data completionHandler:(void(^)(NSArray *result))completionHandler {
    NSArray *result = data[@"data"];
    NSMutableArray *articles = [NSMutableArray new];
    
    for (NSDictionary *dict in result) {
        [articles addObject:[[Article alloc] initWithDictionary:dict]];
    }
    
    if (completionHandler) {
        completionHandler([NSArray arrayWithArray:articles]);
    }
}

@end
